provider "azurerm" {
  features {}
}

locals {
  name        = "app2-firewall"
  environment = "test"
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azurerm"
  version     = "1.0.3"
  name        = local.name
  environment = local.environment
  label_order = ["name", "environment", ]
  location    = "East US"
}

##-----------------------------------------------------------------------------
## Virtual Network module call.
## Virtual Network in firewall specific subnet will be created.
##-----------------------------------------------------------------------------
module "vnet" {
  depends_on          = [module.resource_group]
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.4"
  name                = local.name
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## Subnet module call.
## Name specific subnet for firewall will be created.
##-----------------------------------------------------------------------------
module "name_specific_subnet" {
  depends_on           = [module.vnet]
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.2"
  environment          = "test"
  label_order          = ["name", "environment", "location"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "AzureFirewallSubnet"
      subnet_prefixes = ["10.0.1.0/24"]
    }
  ]
  enable_route_table = true
  route_tables = [
    {
      name = "route-table"
      routes = [
        {
          name           = "route-table"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}

##-----------------------------------------------------------------------------
## Log Analytic Module Call.
## Log Analytic workspace for firerwall diagnostic setting.
##-----------------------------------------------------------------------------
module "log-analytics" {
  source                      = "terraform-az-modules/log-analytics/azurerm"
  version                     = "1.0.3"
  name                        = local.name
  environment                 = local.environment
  label_order                 = ["name", "environment", "location"]
  log_analytics_workspace_sku = "PerGB2018"
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
}



##-----------------------------------------------------------------------------
## Firewall module call.
## All firewall related resources will be deployed from this module, i.e. including firewall and firewall rules.
##-----------------------------------------------------------------------------
module "firewall" {
  depends_on                 = [module.name_specific_subnet]
  source                     = "../.."
  name                       = local.name
  environment                = local.environment
  resource_group_name        = module.resource_group.resource_group_name
  location                   = module.resource_group.resource_group_location
  subnet_id                  = module.name_specific_subnet.subnet_ids["AzureFirewallSubnet"]
  firewall_enable            = true
  policy_rule_enabled        = true
  public_ip_names            = ["ingress", "vnet", "app", "app-2"]
  enable_diagnostic          = true
  eventhub_name              = local.name
  public_ip_prefix_enable    = true
  log_analytics_workspace_id = module.log-analytics.workspace_id
  logs = [{
    category = "AzureFirewallApplicationRule"
    },
  ]

  application_rule_collection = [
    {
      name     = "example_app_policy"
      priority = 200
      action   = "Allow"
      rules = [
        {
          name              = "app_test"
          source_addresses  = ["*"] // ["X.X.X.X"]
          destination_fqdns = ["*"] // ["X.X.X.X"]
          protocols = [
            {
              port = "443"
              type = "Https"
            },
            {
              port = "80"
              type = "Http"
            }
          ]
        }
      ]
    }
  ]
  network_rule_collection = [
    {
      name     = "example_network_policy"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "ssh"
          protocols             = ["TCP"]
          source_addresses      = ["*"] // ["X.X.X.X"]
          destination_addresses = ["*"] // ["X.X.X.X"]
          destination_ports     = ["22"]
        }

      ]
    },
    {
      name     = "example_network_policy-2"
      priority = 101
      action   = "Allow"
      rules = [
        {
          name                  = "smtp"
          protocols             = ["TCP"]
          source_addresses      = ["*"] // ["X.X.X.X"]
          destination_addresses = ["*"] // ["X.X.X.X"]
          destination_ports     = ["587"]
        }
      ]
    }
  ]

  nat_rule_collection = [
    {
      name     = "example_nat_policy-1"
      priority = 101
      rules = [
        {
          name                = "nat_rule_collection1_rule1"
          protocols           = ["TCP", "UDP"]
          source_addresses    = ["10.0.0.1", "10.0.0.2"]
          destination_ports   = ["80"]
          destination_address = module.firewall.public_ip_addresses["vnet"]
          translated_address  = "192.168.0.1"
          translated_port     = "8080"
        },
      ]
    },
  ]
}
