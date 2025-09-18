output "firewall_id" {
  description = "Firewall ID"
  value       = join("", azurerm_firewall.firewall.*.id)
}

output "firewall_name" {
  value       = join("", azurerm_firewall.firewall.*.name)
  description = "Firewall name"

}

output "public_ip_ids" {
  description = "The IDs of all public IPs"
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.id }
}

output "public_ip_addresses" {
  description = "value of public IP addresses"
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.ip_address } #azurerm_public_ip.public_ip.*.ip_address
}

output "firewall_policy_id" {
  description = "value of firewall policy ID"
  value       = join("", azurerm_firewall_policy.policy.*.id)
}

output "public_ip_prefix_id" {
  description = "value of public IP prefix ID"
  value       = join("", azurerm_public_ip_prefix.pip-prefix.*.id)
}

output "primary_public_ip_address" {
  description = "ID of the primary public IP"
  value       = azurerm_public_ip.primary_public_ip[*].ip_address
}

output "primary_public_ip_id" {
  description = "Primary public IP address"
  value       = azurerm_public_ip.primary_public_ip[*].id

}

output "primary_public_ip_name" {
  description = "Name of the primary public IP"
  value       = azurerm_public_ip.primary_public_ip[*].name

}
