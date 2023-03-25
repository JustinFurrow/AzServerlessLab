output "cdb_rg_name_out" {
    value = azurerm_resource_group.cdb_rg.name
}

output "cdb_account_name_out" {
    value = resource.azurerm_cosmosdb_account.cdb_account.name
}

output "cdb_database_name_out" {
    value = resource.azurerm_cosmosdb_sql_database.cdb_sql.name
}

output "cdb_container_name_out" {
    value = resource.azurerm_cosmosdb_sql_container.cdb_sql_container.name
}

#output "cdb_role_definition_name_out" {
#    value = resource.azurerm_cosmosdb_sql_role_definition.cdb_sql_roledef.name
#}

#output "cdb_role_assignment_name_out" {
#    value = resource.azurerm_cosmosdb_sql_role_assignment.cdb_sql_roleasign.name
#}

output "account_id" {
  value = data.azurerm_client_config.current.client_id
}