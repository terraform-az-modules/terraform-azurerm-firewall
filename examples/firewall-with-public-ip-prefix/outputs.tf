output "firewall_id" {
  description = "Firewall generated id"
  value       = module.firewall.firewall_id

}

output "firewall_name" {
  value       = module.firewall.firewall_name
  description = "The name of the Firewall"


}

output "public_ip_id" {
  value       = module.firewall.public_ip_ids
  description = "value of public IP IDs"
}

output "public_ip_address" {
  value       = module.firewall.public_ip_addresses
  description = "value of public IP Addresses"
}

