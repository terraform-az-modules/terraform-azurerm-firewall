output "firewall_id" {
  description = "Firewall ID"
  value       = join("", [for f in azurerm_firewall.firewall : f.id])
}

output "firewall_name" {
  value       = join("", [for f in azurerm_firewall.firewall : f.name])
  description = "Firewall name"
}

output "public_ip_ids" {
  description = "The IDs of all public IPs"
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.id }
}

output "public_ip_addresses" {
  description = "value of public IP addresses"
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.ip_address }
}

output "firewall_policy_id" {
  description = "value of firewall policy ID"
  value       = join("", [for p in azurerm_firewall_policy.policy : p.id])
}

output "public_ip_prefix_id" {
  description = "value of public IP prefix ID"
  value       = join("", [for p in azurerm_public_ip_prefix.pip_prefix : p.id])
}

