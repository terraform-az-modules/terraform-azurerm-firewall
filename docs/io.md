## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_policy\_collection\_group | (optional) Name of app policy group | `string` | `"DefaultApplicationRuleCollectionGroup"` | no |
| application\_rule\_collection | List of application rule collections for the firewall policy. | <pre>list(object({<br>    name     = string<br>    priority = number<br>    action   = string<br>    rules = list(object({<br>      name                  = string<br>      source_addresses      = optional(list(string), []) # Optional: List of source IP addresses<br>      source_ip_groups      = optional(list(string), []) # Optional: List of source IP groups<br>      destination_fqdns     = optional(list(string), []) # Optional: List of destination FQDNs<br>      destination_ip_groups = optional(list(string), []) # Optional: List of destination IP groups<br>      protocols = list(object({<br>        port = optional(number, null) # Optional: Port number<br>        type = optional(string, null) # Optional: Protocol type (e.g., TCP, UDP)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| custom\_name | Override default naming convention | `string` | `null` | no |
| deployment\_mode | Specifies how the infrastructure/resource is deployed | `string` | `"terraform"` | no |
| dns\_servers | DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy. | `list(string)` | `null` | no |
| enable\_diagnostic | Set to false to prevent the module from creating the diagnostics setting for the firewall Resource.. | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| eventhub\_authorization\_rule\_id | Eventhub authorization rule id to pass it to destination details of diagnosys setting of firewall. | `string` | `null` | no |
| eventhub\_name | Eventhub Name to pass it to destination details of diagnosys setting of firewall. | `string` | `null` | no |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| firewall\_enable | values are true or false. Set to true to enable the firewall creation. If set to false, no firewall will be created. | `bool` | `false` | no |
| firewall\_policy\_id | The ID of the Firewall Policy. | `string` | `null` | no |
| firewall\_private\_ip\_ranges | A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| identity\_type | Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). | `string` | `"UserAssigned"` | no |
| label\_order | Order of labels in the resource name. The order of labels in the resource name. The default order is ['name', 'environment', 'location']. You can change this to ['environment', 'name', 'location'] or any other order as per your requirements. | `list(any)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| location | The location/region where the firewall is created. Changing this forces a new resource to be created. | `string` | `""` | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_workspace\_id | log analytics workspace id to pass it to destination details of diagnosys setting of firewall. | `string` | `null` | no |
| logs | List of logs to enable for the diagnosys setting. | <pre>list(object({<br>    category_group = optional(string)<br>    category       = optional(string)<br>  }))</pre> | `[]` | no |
| managedby | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| metric\_enabled | Set to true to enable metrics for the diagnosys setting. | `bool` | `false` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| nat\_policy\_collection\_group | (optional) Name of nat policy group | `string` | `"DefaultDnatRuleCollectionGroup"` | no |
| nat\_rule\_collection | List of NAT rule collections for the firewall policy. | <pre>list(object({<br>    name        = string<br>    priority    = number<br>    description = optional(string, null) # Optional: Description of the NAT rule collection<br>    rules = list(object({<br>      name                  = string<br>      protocols             = list(string)               # List of protocols (e.g., TCP, UDP)<br>      source_addresses      = optional(list(string), []) # Optional: List of source IP addresses<br>      destination_address   = optional(string, null)     # Optional: List of destination IP addresses<br>      destination_ports     = optional(list(string), []) # Optional: List of destination ports<br>      translated_address    = string                     # Required: Internal IP to which traffic is forwarded<br>      translated_port       = optional(string, null)     # Optional: Internal port to which traffic is forwarded<br>      source_ip_groups      = optional(list(string), []) # Optional: List of source IP groups<br>      destination_ip_groups = optional(list(string), []) # Optional: List of destination IP groups<br>    }))<br>  }))</pre> | `[]` | no |
| net\_policy\_collection\_group | (optional) Name of network policy group | `string` | `"DefaultNetworkRuleCollectionGroup"` | no |
| network\_rule\_collection | List of network rule collections for the firewall policy. | <pre>list(object({<br>    name        = string<br>    priority    = number<br>    action      = string<br>    description = optional(string, null) # Optional: Description of the rule collection<br>    rules = list(object({<br>      name                  = string<br>      protocols             = list(string)               # List of protocols (e.g., TCP, UDP, ICMP)<br>      source_addresses      = optional(list(string), []) # Optional: List of source IP addresses<br>      source_ip_groups      = optional(list(string), []) # Optional: List of source IP groups<br>      destination_addresses = optional(list(string), []) # Optional: List of destination IP addresses<br>      destination_ip_groups = optional(list(string), []) # Optional: List of destination IP groups<br>      destination_ports     = optional(list(string), []) # Optional: List of destination ports<br>      destination_fqdns     = optional(list(string), []) # Optional: List of destination FQDNs<br>    }))<br>  }))</pre> | `[]` | no |
| policy\_rule\_enabled | Flag used to control creation of policy rules. | `bool` | `false` | no |
| public\_ip\_allocation\_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic | `string` | `"Static"` | no |
| public\_ip\_names | List of public IP names to create. | `list(string)` | `[]` | no |
| public\_ip\_prefix\_enable | Flag to control creation of public ip prefix resource. | `bool` | `false` | no |
| public\_ip\_prefix\_ip\_version | The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Default is IPv4 | `string` | `"IPv4"` | no |
| public\_ip\_prefix\_length | Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses). Defaults to 28(16 addresses). Changing this forces a new resource to be created. | `number` | `28` | no |
| public\_ip\_prefix\_sku | SKU for public ip prefix. Default to standard. | `string` | `"Standard"` | no |
| public\_ip\_sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard | `string` | `"Standard"` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-azure-firewall"` | no |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | `""` | no |
| resource\_position\_prefix | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.<br><br>- If true, the keyword is prepended: "vnet-core-dev".<br>- If false, the keyword is appended: "core-dev-vnet".<br><br>This helps maintain naming consistency based on organizational preferences. | `bool` | `true` | no |
| sku\_name | SKU name of the Firewall. Possible values are `AZFW_VNet` and `AZFW_Hub`. | `string` | `"AZFW_VNet"` | no |
| sku\_policy | Specifies the firewall-policy sku | `string` | `"Standard"` | no |
| sku\_tier | Specifies the firewall sku tier | `string` | `"Standard"` | no |
| storage\_account\_id | Storage account id to pass it to destination details of diagnosys setting of firewall. | `string` | `null` | no |
| subnet\_id | The ID of the subnet to attach the firewall to. If not specified, the module will create a new subnet named 'AzureFirewallSubnet' in the specified virtual network. | `string` | `""` | no |
| threat\_intel\_mode | (Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny. Defaults to Alert. | `string` | `"Alert"` | no |

## Outputs

| Name | Description |
|------|-------------|
| firewall\_id | Firewall ID |
| firewall\_name | Firewall name |
| firewall\_policy\_id | value of firewall policy ID |
| public\_ip\_addresses | value of public IP addresses |
| public\_ip\_ids | The IDs of all public IPs |
| public\_ip\_prefix\_id | value of public IP prefix ID |

