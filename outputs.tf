output "firewall_id" {
  description = "Firewall ID"
  value       = join("", azurerm_firewall.firewall.*.id)
}

output "firewall_name" {
  value       = join("", azurerm_firewall.firewall.*.name)
  description = "Firewall name"

}

output "public_ip_id" {
  description = "value of public IP ID"
  value       = azurerm_public_ip.public_ip.*.id
}

output "public_ip_address" {
  description = "value of public IP address"
  value       = azurerm_public_ip.public_ip.*.ip_address
}

output "firewall_policy_id" {
  description = "value of firewall policy ID"
  value       = join("", azurerm_firewall_policy.policy.*.id)
}

output "prefix_public_ip_id" {
  description = "value of prefix public IP ID"
  value       = azurerm_public_ip.public_ip.*.id
}

output "prefix_public_ip_address" {
  description = "value of prefix public IP address"
  value       = azurerm_public_ip.public_ip.*.ip_address
}

output "public_ip_prefix_id" {
  description = "value of public IP prefix ID"
  value       = join("", azurerm_public_ip_prefix.pip-prefix.*.id)
}
