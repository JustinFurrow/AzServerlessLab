# to add for API Management - Identity (for RBAC), Virtual Network integration, Azure resourece monitor/logging, 
resource "azurerm_api_management" "api_mng" {
  name                = var.api_mng_name
  location            = azurerm_resource_group.var.cdb_rgname.location
  resource_group_name = azurerm_resource_group.var.cdb_rgname.name
  publisher_name      = var.publisher_email
  publisher_email     = var.publisher_name
  sku_name = "${var.sku}_${var.sku_count}"

#  From ChatGPT. Don't trust it. 
#  identity {
#    type = "SystemAssigned"
#  }