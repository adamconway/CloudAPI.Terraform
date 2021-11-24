locals {
  resource_suffix = "cloudapi-${var.environment_name}-aueast"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-data-${local.resource_suffix}"
  location = var.region
}

resource "azurerm_cosmosdb_account" "db" {
  name     = "cosmos-${local.resource_suffix}"
  location = var.region
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = false

  enable_free_tier = true

#  capabilities {
#    name = "EnableServerless"
#  }

  consistency_policy {
    consistency_level       = "Eventual"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}