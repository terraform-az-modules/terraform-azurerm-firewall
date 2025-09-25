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

output "primary_public_ip_id" {
  value       = module.firewall.primary_public_ip_id
  description = "The Primary public IP associated with the firewall"

}

output "primary_public_ip_address" {
  value       = module.firewall.primary_public_ip_address
  description = "The Primary public IP address associated with the firewall"
}
