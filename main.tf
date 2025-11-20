##-----------------------------------------------------------------------------
# Standard Tagging Module – Applies standard tags to all resources for traceability
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.custom_name == null ? var.name : var.custom_name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
# Firewall Public IP Prefix – optional
##-----------------------------------------------------------------------------
resource "azurerm_public_ip_prefix" "pip_prefix" {
  count               = var.enabled && var.firewall_enable && var.public_ip_prefix_enable ? 1 : 0
  name                = format(var.resource_position_prefix ? "public-ip-prefix-%s" : "%s-public-ip-prefix", local.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.public_ip_prefix_sku
  ip_version          = var.public_ip_prefix_ip_version
  prefix_length       = var.public_ip_prefix_length
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
# Public IPs – one resource, creates all PIPs
##-----------------------------------------------------------------------------
resource "azurerm_public_ip" "public_ip" {
  for_each             = toset(var.public_ip_names)
  name                 = var.public_ip_prefix_enable ? format(var.resource_position_prefix ? "pip-%s-%s" : "%s-%s-pip", local.name, each.value) : format(var.resource_position_prefix ? "ip-%s-%s" : "%s-%s-ip", local.name, each.value)
  location             = var.location
  resource_group_name  = var.resource_group_name
  allocation_method    = var.public_ip_allocation_method
  sku                  = var.public_ip_sku
  public_ip_prefix_id  = var.public_ip_prefix_enable && length(azurerm_public_ip_prefix.pip_prefix) > 0 ? azurerm_public_ip_prefix.pip_prefix[0].id : null
  ddos_protection_mode = "VirtualNetworkInherited"
  tags                 = module.labels.tags

  lifecycle {
    create_before_destroy = true
  }
}

##-----------------------------------------------------------------------------
# Azure Firewall
##-----------------------------------------------------------------------------
resource "azurerm_firewall" "firewall" {
  depends_on          = [azurerm_public_ip.public_ip, azurerm_public_ip_prefix.pip_prefix]
  count               = var.enabled && var.firewall_enable ? 1 : 0
  name                = format(var.resource_position_prefix ? "firewall-%s" : "%s-firewall", local.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  threat_intel_mode   = var.threat_intel_mode
  sku_tier            = var.sku_tier
  sku_name            = var.sku_name
  firewall_policy_id  = join("", [for p in azurerm_firewall_policy.policy : p.id])
  tags                = module.labels.tags
  private_ip_ranges   = var.firewall_private_ip_ranges
  dns_servers         = var.dns_servers

  # Primary ip_configuration (first in the list)
  ip_configuration {
    name                 = format(var.resource_position_prefix ? "ipconfig-%s-%s" : "%s-%s-ipconfig", local.name, var.public_ip_names[0])
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.public_ip[var.public_ip_names[0]].id
  }

  # Additional ip_configurations (skip first one)
  dynamic "ip_configuration" {
    for_each = length(var.public_ip_names) > 1 ? toset(slice(var.public_ip_names, 1, length(var.public_ip_names))) : []
    content {
      name                 = format(var.resource_position_prefix ? "ipconfig-%s-%s" : "%s-%s-ipconfig", local.name, ip_configuration.value)
      public_ip_address_id = azurerm_public_ip.public_ip[ip_configuration.value].id
      # subnet_id omitted here!
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

##-----------------------------------------------------------------------------
# Firewall Policy
##-----------------------------------------------------------------------------
resource "azurerm_firewall_policy" "policy" {
  count               = var.enabled && var.firewall_enable ? 1 : 0
  name                = format(var.resource_position_prefix ? "firewall-policy-%s" : "%s-firewall-policy", local.name)
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_policy

  dynamic "identity" {
    for_each = var.identity_type != null && var.sku_policy == "Premium" && var.sku_tier == "Premium" ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? [for i in azurerm_user_assigned_identity.identity : i.id] : null
    }
  }
}

##-----------------------------------------------------------------------------
# Firewall Policy Rule Collection Groups
##-----------------------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "app_policy" {
  depends_on         = [azurerm_firewall_policy.policy]
  count              = var.enabled && var.policy_rule_enabled ? 1 : 0
  name               = var.app_policy_collection_group
  firewall_policy_id = var.firewall_policy_id == null ? join("", [for p in azurerm_firewall_policy.policy : p.id]) : var.firewall_policy_id
  priority           = 300

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collection
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = lookup(rule.value, "name", null)
          source_addresses  = lookup(rule.value, "source_addresses", null)
          source_ip_groups  = lookup(rule.value, "source_ip_groups", null)
          destination_fqdns = lookup(rule.value, "destination_fqdns", null)

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              port = lookup(protocols.value, "port", null)
              type = lookup(protocols.value, "type", null)
            }
          }
        }
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "network_policy" {
  depends_on         = [azurerm_firewall_policy.policy]
  count              = var.enabled && var.policy_rule_enabled ? 1 : 0
  name               = var.net_policy_collection_group
  firewall_policy_id = var.firewall_policy_id == null ? join("", [for p in azurerm_firewall_policy.policy : p.id]) : var.firewall_policy_id
  priority           = 200

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collection
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          destination_ports     = rule.value.destination_ports
          source_addresses      = lookup(rule.value, "source_addresses", null)
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)
          destination_addresses = lookup(rule.value, "destination_addresses", null)
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", null)
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null)
        }
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "nat_policy" {
  depends_on         = [azurerm_firewall_policy.policy]
  count              = var.enabled && var.policy_rule_enabled ? 1 : 0
  name               = var.nat_policy_collection_group
  firewall_policy_id = var.firewall_policy_id == null ? join("", [for p in azurerm_firewall_policy.policy : p.id]) : var.firewall_policy_id
  priority           = 100

  dynamic "nat_rule_collection" {
    for_each = var.nat_rule_collection
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = "Dnat"

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols
          destination_ports   = rule.value.destination_ports
          source_addresses    = lookup(rule.value, "source_addresses", null)
          destination_address = lookup(rule.value, "destination_address", null)
          translated_address  = lookup(rule.value, "translated_address", null)
          translated_port     = lookup(rule.value, "translated_port", null)
        }
      }
    }
  }
}

##-----------------------------------------------------------------------------
# Diagnostics
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "firewall_diagnostic" {
  count                          = var.enabled && var.enable_diagnostic && var.firewall_enable ? 1 : 0
  name                           = format(var.resource_position_prefix ? "firewall-diagnostic-%s" : "%s-firewall-diagnostic", local.name)
  target_resource_id             = azurerm_firewall.firewall[0].id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "enabled_metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = enabled_metric.value
    }
  }

  dynamic "enabled_log" {
    for_each = var.logs
    content {
      category_group = lookup(enabled_log.value, "category_group", null)
      category       = lookup(enabled_log.value, "category", null)
    }
  }
}
