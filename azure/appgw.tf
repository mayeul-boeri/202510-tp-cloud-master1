resource "azurerm_public_ip" "appgw" {
  name                = "${var.project_name}-appgw-ip"
  location            = var.location
  resource_group_name = "RG-TP-Cloud"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.project_name}-appgw"
  location            = var.location
  resource_group_name = "RG-TP-Cloud"
  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.subnets["frontend"].id
  }
  frontend_port {
    name = "frontendPort"
    port = 80
  }
  frontend_port {
    name = "frontendPort443"
    port = 443
  }
  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }
  backend_address_pool {
    name  = "backendPool"
    # Ajoutez ici les adresses IP ou FQDN des serveurs backend
  }
  backend_http_settings {
    name                  = "httpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }
  http_listener {
    name                           = "appgw-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "frontendPort"
    protocol                      = "Http"
  }
  http_listener {
    name                           = "appgw-listener-443"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "frontendPort443"
    protocol                      = "Https"
    ssl_certificate_name           = null # Ajoutez le certificat SSL si besoin
  }
  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-listener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
  }
  request_routing_rule {
    name                       = "rule2"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-listener-443"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
  }
}
