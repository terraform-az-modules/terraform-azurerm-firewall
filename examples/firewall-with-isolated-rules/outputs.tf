output "firewall_id" {
  description = "Firewall generated id"
  value       = module.firewall.firewall_id
}

output "firewall_name" {
  value       = module.firewall.firewall_name
  description = "Firewall name"

}

output "public_ip_id" {
  value = module.firewall.public_ip_ids
}

output "public_ip_address" {
  value = module.firewall.public_ip_addresses
}
