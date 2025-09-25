
##------------------------------------------------------------------------------------
# User Assigned Identity – Creates a user assigned identity for Azure Firewall Policy
##------------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity" {
  count               = var.enabled && var.firewall_enable ? 1 : 0
  location            = var.location
  name                = format(var.resource_position_prefix ? "fw-policy-mid-%s" : "%s-fw-policy-mid", local.name)
  resource_group_name = var.resource_group_name
}
