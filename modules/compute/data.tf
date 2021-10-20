data "azurerm_resource_group" "core" {
  name     = "rg-core-${local.resource_suffix}"
}