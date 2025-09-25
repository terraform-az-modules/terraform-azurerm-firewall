<!-- BEGIN_TF_DOCS -->

# Terraform Azure Application Insights

This directory contains an example usage of the **terraform-azure-firewall**. It demonstrates how to use the module with default settings or with custom configurations.

---

## 📋 Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.116.0 |

---

## 🔌 Providers

None specified in this example.

---

## 📦 Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ../.. | n/a |
| <a name="module_log-analytics"></a> [log-analytics](#module\_log-analytics) | terraform-az-modules/log-analytics/azure | 1.0.0 |
| <a name="module_name_specific_subnet"></a> [name\_specific\_subnet](#module\_name\_specific\_subnet) | terraform-az-modules/subnet/azure | 1.0.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-az-modules/resource-group/azure | 1.0.0 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | terraform-az-modules/vnet/azure | 1.0.0 |

---

## 🏗️ Resources

No resources are directly created in this example.

---

## 🔧 Inputs

No input variables are defined in this example.

---

## 📤 Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | Firewall generated id |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | The name of the Firewall |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | value of public IP Addresses |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | value of public IP IDs |

<!-- END_TF_DOCS -->
