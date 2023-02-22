terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Azure Cosmos DB Resource Group
resource "azurerm_resource_group" "rg-cdb-westus-002" {
  name     = "rg-cdb-westus-002"
  location = "West US 2"
}

# Azure Cosmos DB account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "gbcosmosdb-${UniqueStringAz}"
  location            = azurerm_resource_group.rg-cdb-westus-002.location
  resource_group_name = azurerm_resource_group.rg-cdb-westus-002.name
  offer_type          = "Standard"
  #can also choose "MongoDB" - look into this later, good to build experience with multiple options
  kind = "GlobalDocumentDB"
  #local_authentication_disabled = true
  #change the above for improved security once properly configured

  enable_automatic_failover = true

  #what capabilities do we want to add?

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg-cdb-westus-002.location
    failover_priority = 0
  }
}
