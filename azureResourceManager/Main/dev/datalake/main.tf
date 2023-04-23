
data "azurerm_resource_group" "this" {
  name =  var.resource_group_name
}

module "datalakegen2001" {
 source = "../../../Modules/global/adlsGen2"
 resource_group_name = var.resource_group_name
 storage_name = var.storage_name_001
}