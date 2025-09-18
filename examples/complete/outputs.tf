output "firewall_id" {
  description = "Firewall generated id"
  value       = module.firewall.firewall_id
}
output "public_ip_id" {
  value = module.firewall.public_ip_ids
}

output "public_ip_address" {
  value = module.firewall.public_ip_addresses
}

output "primary_public_ip_id" {
  value = module.firewall.primary_public_ip_id

}

output "primary_public_ip_address" {
  value = module.firewall.primary_public_ip_address
}
