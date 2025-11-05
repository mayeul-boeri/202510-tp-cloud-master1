resource "azurerm_virtual_network" "tp_vnet" {
    name                = "${var.project_name}-vnet"
    location            = azurerm_resource_group.rg_tp_cloud.location
    resource_group_name = azurerm_resource_group.rg_tp_cloud.name
}

resource "azurerm_subnet" "subnets" {
    for_each              = { for subnet in var.subnets : subnet.name => subnet }
    name                 = each.value.name
    resource_group_name  = azurerm_resource_group.rg_tp_cloud.name
    virtual_network_name = azurerm_virtual_network.tp_vnet.name
    address_prefixes    = [each.value.cidr]
}

