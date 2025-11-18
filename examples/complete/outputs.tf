output "firewall_id" {
  description = "Firewall generated id"
  value       = module.firewall.firewall_id
}
output "public_ip_id" {
  value       = module.firewall.public_ip_ids
  description = "The public IP associated with the firewall"
}

output "public_ip_address" {
  value       = module.firewall.public_ip_addresses
  description = "The public IP address associated with the firewall"
}

output "firewall_policy_id" {
  description = "Firewall Policy generated id"
  value       = module.firewall.firewall_policy_id
}

output "public_ip_prefix_id" {
  description = "Public IP Prefix generated id"
  value       = module.firewall.public_ip_prefix_id
}
