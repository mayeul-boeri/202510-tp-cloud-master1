#cree une ip publique pour le bastion

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${var.project_name}-bastion-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#cree le bastion dnas le sous reseau
resource "azurerm_bastion_host" "bastion_host" {
  name                = "${var.project_name}-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.subnets["azurebastionsubnet"].id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}