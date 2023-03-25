#review if this is still needed once you create the API module
#output "api_management_service_name" {
#  value = azurerm_api_management.api.name
#}

output "cdb_account_name" {
  value = module.CosmosDB.cdb_account_name_out
}

output "cdb_rg_name" {
  value = module.CosmosDB.cdb_rg_name_out
}

output "cdb_database_name" {
    value = module.CosmosDB.cdb_database_name_out
}

output "cdb_container_name" {
    value = module.CosmosDB.cdb_container_name_out
}

#output "cdb_role_definition_name" {
 #   value = module.CosmosDB.cdb_role_definition_name_out
#}

#output "cdb_role_assignment_name" {
#    value = module.CosmosDB.cdb_role_assignment_name_out
#}