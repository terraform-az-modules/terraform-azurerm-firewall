##-----------------------------------------------------------------------------
## Naming convention
##-----------------------------------------------------------------------------
variable "custom_name" {
  type        = string
  default     = null
  description = "Override default naming convention"
}

variable "resource_position_prefix" {
  type        = bool
  default     = true
  description = <<EOT
Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

- If true, the keyword is prepended: "vnet-core-dev".
- If false, the keyword is appended: "core-dev-vnet".

This helps maintain naming consistency based on organizational preferences.
EOT
}

##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "location" {
  type        = string
  default     = ""
  description = "The location/region where the firewall is created. Changing this forces a new resource to be created."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "Order of labels in the resource name. The order of labels in the resource name. The default order is ['name', 'environment', 'location']. You can change this to ['environment', 'name', 'location'] or any other order as per your requirements."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azure-firewall"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

#-----------------------------------------------------------------------------
# Global configuration
#-----------------------------------------------------------------------------
variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources."
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "firewall_enable" {
  type        = bool
  default     = false
  description = "values are true or false. Set to true to enable the firewall creation. If set to false, no firewall will be created."
}

#-----------------------------------------------------------------------------
# Public IP configuration
#-----------------------------------------------------------------------------
variable "public_ip_names" {
  type        = list(string)
  default     = []
  description = "List of public IP names to create."
  validation {
    condition     = (!var.firewall_enable) || length(var.public_ip_names) >= 1
    error_message = "At least one public_ip_names entry is required when firewall_enable = true."
  }
}

variable "public_ip_prefix_enable" {
  type        = bool
  default     = false
  description = "Flag to control creation of public ip prefix resource."

}

# variable "primary_public_ip_name" {
#   description = "One of public_ip_names. Used for the subneted ip_configuration."
#   type        = string
# }

variable "public_ip_allocation_method" {
  type        = string
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  default     = "Static"
}


variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard"
  default     = "Standard"
  type        = string
}

variable "public_ip_prefix_sku" {
  type        = string
  default     = "Standard"
  description = "SKU for public ip prefix. Default to standard."
}

variable "public_ip_prefix_ip_version" {
  type        = string
  default     = "IPv4"
  description = "The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Default is IPv4"
}

variable "public_ip_prefix_length" {
  type        = number
  default     = 28
  description = "Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses). Defaults to 28(16 addresses). Changing this forces a new resource to be created."
}

#-----------------------------------------------------------------------------
# Firewall configuration
#-----------------------------------------------------------------------------
variable "threat_intel_mode" {
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny. Defaults to Alert."
  default     = "Alert"
  type        = string

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.threat_intel_mode)
    error_message = "The threat intel mode is invalid."
  }
}

variable "sku_tier" {
  description = "Specifies the firewall sku tier"
  default     = "Standard"
  type        = string
}

variable "sku_name" {
  type        = string
  default     = "AZFW_VNet"
  description = "SKU name of the Firewall. Possible values are `AZFW_VNet` and `AZFW_Hub`."
}

variable "firewall_private_ip_ranges" {
  description = "A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "dns_servers" {
  description = "DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy."
  type        = list(string)
  default     = null
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "The ID of the subnet to attach the firewall to. If not specified, the module will create a new subnet named 'AzureFirewallSubnet' in the specified virtual network."
}

#-----------------------------------------------------------------------------
# Firewall Policy configuration
#-----------------------------------------------------------------------------
variable "sku_policy" {
  description = "Specifies the firewall-policy sku"
  default     = "Standard"
  type        = string
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "UserAssigned"
}

#-----------------------------------------------------------------------------
# Policy Rule Collection Group configuration
#-----------------------------------------------------------------------------
variable "policy_rule_enabled" {
  type        = bool
  default     = false
  description = "Flag used to control creation of policy rules."
}

variable "app_policy_collection_group" {
  type        = string
  default     = "DefaultApplicationRuleCollectionGroup"
  description = "(optional) Name of app policy group"
}

variable "firewall_policy_id" {
  type        = string
  default     = null
  description = "The ID of the Firewall Policy."
}

variable "application_rule_collection" {
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                  = string
      source_addresses      = optional(list(string), []) # Optional: List of source IP addresses
      source_ip_groups      = optional(list(string), []) # Optional: List of source IP groups
      destination_fqdns     = optional(list(string), []) # Optional: List of destination FQDNs
      destination_ip_groups = optional(list(string), []) # Optional: List of destination IP groups
      protocols = list(object({
        port = optional(number, null) # Optional: Port number
        type = optional(string, null) # Optional: Protocol type (e.g., TCP, UDP)
      }))
    }))
  }))
  default     = []
  description = "List of application rule collections for the firewall policy."
}

#-----------------------------------------------------------------------------
# Network Rule configuration
#-----------------------------------------------------------------------------
variable "net_policy_collection_group" {
  type        = string
  description = "(optional) Name of network policy group"
  default     = "DefaultNetworkRuleCollectionGroup"
}

variable "network_rule_collection" {
  type = list(object({
    name        = string
    priority    = number
    action      = string
    description = optional(string, null) # Optional: Description of the rule collection
    rules = list(object({
      name                  = string
      protocols             = list(string)               # List of protocols (e.g., TCP, UDP, ICMP)
      source_addresses      = optional(list(string), []) # Optional: List of source IP addresses
      source_ip_groups      = optional(list(string), []) # Optional: List of source IP groups
      destination_addresses = optional(list(string), []) # Optional: List of destination IP addresses
      destination_ip_groups = optional(list(string), []) # Optional: List of destination IP groups
      destination_ports     = optional(list(string), []) # Optional: List of destination ports
      destination_fqdns     = optional(list(string), []) # Optional: List of destination FQDNs
    }))
  }))
  default     = []
  description = "List of network rule collections for the firewall policy."
}

#-----------------------------------------------------------------------------
# Nat Rule configuration
#-----------------------------------------------------------------------------
variable "dnat_destination_ip" {
  description = "Variable to specify that you have destination ip to attach to policy or not.(Destination ip is public ip that is attached to firewall)"
  type        = bool
  default     = true
}

variable "nat_policy_collection_group" {
  type        = string
  default     = "DefaultDnatRuleCollectionGroup"
  description = "(optional) Name of nat policy group"
}

variable "nat_rule_collection" {
  description = "List of NAT rule collections for the firewall policy."
  type = list(object({
    name        = string
    priority    = number
    description = optional(string, null) # Optional: Description of the NAT rule collection
    rules = list(object({
      name                  = string
      protocols             = list(string)               # List of protocols (e.g., TCP, UDP)
      source_addresses      = optional(list(string), []) # Optional: List of source IP addresses
      destination_address   = optional(string, null)     # Optional: List of destination IP addresses
      destination_ports     = optional(list(string), []) # Optional: List of destination ports
      translated_address    = string                     # Required: Internal IP to which traffic is forwarded
      translated_port       = optional(string, null)     # Optional: Internal port to which traffic is forwarded
      source_ip_groups      = optional(list(string), []) # Optional: List of source IP groups
      destination_ip_groups = optional(list(string), []) # Optional: List of destination IP groups
    }))
  }))
  default = []
}

#-----------------------------------------------------------------------------
# Diagnostic settings configuration
#-----------------------------------------------------------------------------
variable "enable_diagnostic" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating the diagnosys setting for the firewall Resource.."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "Storage account id to pass it to destination details of diagnosys setting of firewall."
}

variable "eventhub_name" {
  type        = string
  default     = null
  description = "Eventhub Name to pass it to destination details of diagnosys setting of firewall."
}

variable "eventhub_authorization_rule_id" {
  type        = string
  default     = null
  description = "Eventhub authorization rule id to pass it to destination details of diagnosys setting of firewall."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "log analytics workspace id to pass it to destination details of diagnosys setting of firewall."
}

variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}

variable "metric_enabled" {
  type        = bool
  default     = false
  description = "Set to true to enable metrics for the diagnosys setting."
}

variable "logs" {
  type = list(object({
    category_group = optional(string)
    category       = optional(string)
  }))
  default     = []
  description = "List of logs to enable for the diagnosys setting."
}
