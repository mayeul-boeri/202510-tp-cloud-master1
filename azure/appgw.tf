resource "azurerm_public_ip" "appgw" {
  name                = "${var.project_name}-appgw-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "standard_zr" {
  name                = "${var.project_name}-public-ip-zr"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}



resource "azurerm_application_gateway" "appgw_waf_v2" {
  name                = "${var.project_name}-appgw-waf-v2"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  zones               = ["1", "2"]
  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.subnets["frontend"].id
  }
  frontend_port {
    name = "frontendPort"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.standard_zr.id
  }
  backend_address_pool {
    name = "backendPool"
    # Vide pour l'instant, à compléter avec VMSS
  }
  probe {
    name                = "health-probe"
    protocol            = "Http"
    host                = "localhost"
    path                = "/health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200"]
    }
  }
  http_listener {
    name                           = "appgw-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "frontendPort"
    protocol                      = "Http"
  }
  request_routing_rule {
    name                       = "rule-http"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-listener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
    priority                   = 100
  }
  backend_http_settings {
    name                  = "httpSettings"
    port                  = 80
    protocol              = "Http"
    probe_name            = "health-probe"
    pick_host_name_from_backend_address = false
    cookie_based_affinity = "Disabled"
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}
