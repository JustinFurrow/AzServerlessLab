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

#from Microsoft Learn page, Azure Cosmos DB account with Azure AD and RBAC
#may require future modification. Based on "Azure Cosmos DB account with Azure AD and role-based access control" https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/manage-with-terraform
data "azurerm_client_config" "current" {}

locals {
  current_user_object_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
}

# Azure Cosmos DB Resource Group
resource "azurerm_resource_group" "cdb-rg" {
  name     = "var.cdb-rgname"
  location = "var.cdb-rglocation"
}

# Azure Cosmos DB account
resource "azurerm_cosmosdb_account" "cdb-account" {
  name                = "var.cdb-accountname"
  location            = azurerm_resource_group.var.cdb-rg.location
  resource_group_name = azurerm_resource_group.var.cdb-rg.name
  offer_type          = "Standard"
  #can also choose "MongoDB" - look into this later, good to build experience with multiple options
  kind = "GlobalDocumentDB"
  # Disable local authentication and ensure only MSI and AAD can be used exclusively for authentication. Can be set only when using the SQL API.
  # For this to work, I need to set up an identity in AAD which has the ability to authenticate to CDB. 
  #local_authentication_disabled = true
    enable_automatic_failover = true
  #what capabilities do we want to add?

  # enforce TLS 1.2
  min_tls_version = "TLS1_2"

  geo_location {
    location          = azurerm_resource_group.var.cdb-rgname.location
    failover_priority = 0
  }
  
  consistency_policy {
    consistency_level = "Session"
  }

  depends_on = [
    azurerm_resource_group.var.cdb-rgname
  ]
}

resource "azurerm_cosmosdb_sql_database" "cdb-sql" {
  # I need to find a good way to have $UniqueStringAz stored securely, in a way that variables.tf can pull from it
  name = var.cdb_sqldb_name
  resource_group_name = azurerm_resource_group.var.cdb-rg.name
  account_name = azurerm_cosmosdb_account.cdb-account.name
  # NOTE: Do not set throughput when azurerm_cosmosdb_account is configured with EnableServerless - which I will want to do later on.
  throughput = var.throughput
}

resource "azurerm_cosmosdb_sql_container" "cdb-sql-container" {
  name = var.sql_container_name
  resource_group_name = azurerm_resource_group.var.cdb-rg.name
  account_name = azurerm_cosmosdb_account.cdb-account.name
  database_name = azurerm_cosmosdb_sql_database.cdb-sql.name
  #i need to read up on partition_key_path more
  partition_key_path = "/definition/id"
  partition_key_version = 1
  throughput = 400

  # If an explicitly indexed path doesn't exist in an item, a value will be added to the index to indicate that the path is undefined.
  # a path leading to a scalar value (string or number) ends with /?
  # the /* wildcard can be used to match any elements below the node

  # Consistent index policy - index is updated synchronously as you create/update/delete items. Read query consistency will be the consistency configured for the account. (in this case, that would be Session)
  indexing_policy {
    indexing_mode = "consistent"

    # including the root path allows you to select which specific paths should be excluded. Microsoft recommends this to leve CDB index any new property that gets added. 
    included_path {
      path = "/*"
    }

    # All explicitly included paths will have values added to the index for each item in the container, even if the path is undefined for a given item.
    included_path {
      path = "/included/?"
    }

    # if this were root, we would selectively include paths to be indexed. 
    # by designating specific exclusions, we say "any data in this path or nested within is excluded from the index - unless a more specific included path is available"
    excluded_path  {
      path = "/excluded/?"
    }
  }

  # Unique keys add a layer of data integrity to an Azure CDB container. The partition key combined with the unique key guarantees the uniqueness of an item within the scope of the container.
  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

# need to update some of the variables
# RBAC role definition
resource "azurerm_cosmosdb_sql_role_definition" "cdb-sql-roledef" {
  #update name with a variable in the future
  name = cdb-sql-roledef
  resource_group_name = azurerm_resource_group.var.cdb-rgname.name
  account_name = azurerm_cosmosdb_account.cdb-account.name
  #type = "CustomRole"
  #assignable_scopes = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.example.name}/providers/Microsoft.DocumentDB/databaseAccounts/${azurerm_cosmosdb_account.example.name}"]
  #permissions {
    #data_actions = ["Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read"]
    #}
}

# Need to change scope from default example from Microsoft documentation
# RBAC role assignment
resource "azurerm_cosmosdb_sql_role_assignment" "cdb-sql-roleasign" {
  name = cdb-sql-roleasign
  resource_group_name = azurerm_resource_group.var.cdb-rgname.name
  account_name = azurerm_cosmosdb_account.cdb-account.name
  role_definition_id = azurerm_cosmosdb_sql_role_definition.cdb-sql-roledef.id
  #principal_id = local.current_user_object_id
  #scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.var.cdb-rgname.name}/providers/Microsoft.DocumentDB/databaseAccounts/${azurerm_cosmosdb_account.cdb-account.name}"
}

#could this be how they're doing the unique ID?
#resource "random_pet" "prefix" {
#  prefix = var.name_prefix
#}