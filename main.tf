module "CosmosDB" {
  source = "./CosmosDB"
  base_name = var.cdb_rg_name
  # can we try cdb_rg_name from root folder outputs to make this even more simple?
  resource_group_name = module.CosmosDB.cdb_rg_name_out
  location = "West US 2"
}

#  fill this out once you've got networking in place
#  virtual_network {
#    type             = "External"
#    subnet_id        = "/subscriptions/subscription_id/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet"
#    private_ip_address_allocation = "Static"
#    private_ip_address             = "10.0.0.4"
#  }


#resource "azurerm_monitor_diagnostic_setting" "example" {
#  name               = "example-apim-diagnostics"
 # target_resource_id = azurerm_api_management.example.id
#
 # log_analytics_workspace_id = "/subscriptions/subscription_id/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace"
#
 # metric {
  #  category = "AllMetrics"
#
 #   retention_policy {
  #    enabled = true
   #   days    = 365
    #}
  #}

  #log {
   # category = "GatewayLogs"
    #enabled  = true
#
 #   retention_policy {
  #    enabled = true
   #   days    = 365
    #}
  #}
#}




