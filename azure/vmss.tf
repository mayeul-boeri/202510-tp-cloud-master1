resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  computer_name_prefix = "${var.project_name}-vm"
  disable_password_authentication = false

  extension {
    name                 = "HealthExtension"
    publisher            = "Microsoft.ManagedServices"
    type                 = "ApplicationHealthLinux"
    type_handler_version = "1.0"
    settings = <<SETTINGS
      {
        "protocol": "http",
        "port": 80,
        "requestPath": "/health"
      }
    SETTINGS
  }
  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }
  name                = "${var.project_name}-vmss"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  sku                 = "Standard_B2s"
  instances           = 2
  zones               = ["1", "2"]
  upgrade_mode        = "Rolling"

  admin_username      = var.vmss_username
  admin_password      = var.vmss_password

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
set -eux
exec > /var/log/customdata.log 2>&1

apt-get update
apt-get install -y nginx

mkdir -p /var/www/html
echo "Hello from VMSS instance $(hostname)" > /var/www/html/index.html
echo "OK" > /var/www/html/health

systemctl enable nginx
systemctl restart nginx
EOF
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  network_interface {
    name    = "nic"
    primary = true
    ip_configuration {
      name      = "ipconfig"
      subnet_id = azurerm_subnet.subnets["backend"].id
      application_gateway_backend_address_pool_ids = [for pool in azurerm_application_gateway.appgw_waf_v2.backend_address_pool : pool.id]
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "${var.project_name}-vmss-autoscale"
  resource_group_name = azurerm_resource_group.rg_tp_cloud.name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.web_vmss.id

  profile {
    name = "default"
    capacity {
      minimum = 2
      maximum = 6
      default = 2
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}
