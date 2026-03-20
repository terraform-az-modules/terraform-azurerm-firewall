provider "azurerm" {
  features {}
}

module "firewall" {
  source = "../../"
}
