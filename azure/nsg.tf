resource "azurerm_network_security_group" "frontend" {
  name                = "NSG-Frontend"
  location            = var.location
  resource_group_name = "RG-TP-Cloud"

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureApplicationGateway"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureApplicationGateway"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "frontend_assoc" {
  subnet_id                 = azurerm_subnet.subnets["frontend"].id
  network_security_group_id = azurerm_network_security_group.frontend.id
}


resource "azurerm_network_security_group" "backend" {
  name                = "NSG-Backend"
  location            = var.location
  resource_group_name = "RG-TP-Cloud"

  security_rule {
    name                       = "Allow-HTTP-From-Frontend"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = azurerm_subnet.subnets["frontend"].address_prefixes[0]
    destination_address_prefix = "*"
  }
}


resource "azurerm_subnet_network_security_group_association" "backend_assoc" {
  subnet_id                 = azurerm_subnet.subnets["backend"].id
  network_security_group_id = azurerm_network_security_group.backend.id
}

resource "azurerm_network_security_group" "database" {
  name                = "NSG-Database"
  location            = var.location
  resource_group_name = "RG-TP-Cloud"

  security_rule {
    name                       = "Allow-MySQL-From-Backend"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = azurerm_subnet.subnets["backend"].address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "database_assoc" {
  subnet_id                 = azurerm_subnet.subnets["database"].id
  network_security_group_id = azurerm_network_security_group.database.id
}
