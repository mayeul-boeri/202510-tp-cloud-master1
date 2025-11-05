resource "azurerm_resource_group" "rg_tp_cloud" {
	name     = "${var.project_name}-rg"
	location = "central-europe"
}