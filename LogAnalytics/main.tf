
# Azure Cosmos DB Resource Group
resource "azurerm_resource_group" "cdb_rg" {
    name = "${var.base_name}RG"
    location = "var.location"
}

# data module
data "azurerm_log_analytics_workspace" "loganalytics" {
  name = var.loganalytics_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_monitor_diagnostic_setting" "cdb_diagnostic"{
  name = var.cdb_log_settings_name
  target_resource_id = azurerm_cosmosdb_account.db.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id

  log {
    category = "DataPlaneRequests"
    enabled = true
  }

  log {
    category = "QueryRuntimeStatistics"
    enabled = true
  }

  log {
    category = "PartitionKeyStatistics"
    enabled = true
  }

  log {
    category = "PartitionKeyRUConsumption"
    enabled = true
  }

  log {
    category = "ControlPlaneRequests"
    enabled = true
  }

  #use either DataPlaneRequests or TableApiRequests, not both
  #log {
  #  category = "TableApiRequests"
  #  enabled = true
  #}

}

#from Microsoft Learn page, Azure Cosmos DB account with Azure AD and RBAC
#may require future modification. Based on "Azure Cosmos DB account with Azure AD and role-based access control" https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/manage-with-terraform
