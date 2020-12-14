

# Create Backend VMSS for App
resource "azurerm_linux_virtual_machine_scale_set" "backendvmss" {
  name                            = "${var.prefix}-backendvmss"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  sku                             = var.instance_type
  instances                       = 2
  admin_username                  = var.uname
  admin_password                  = var.upassword
  disable_password_authentication = false
  computer_name_prefix            = "${var.prefix}backendvm"
  custom_data                     = filebase64("${path.module}/backend.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  network_interface {
    name                      = "bexternal"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.main.id

    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = azurerm_subnet.External.id

      public_ip_address {
        name = "backpip"
      }
    }

    ip_configuration {
      name      = "secondary"
      primary   = false
      subnet_id = azurerm_subnet.External.id
      //load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
    }
  }
  tags = {
    Name                = "${var.environment}-f5vmss"
    environment         = var.environment
    owner               = var.owner
    group               = var.group
    costcenter          = var.costcenter
    application         = var.application
    tag_name            = "Env"
    value               = "consul"
    propagate_at_launch = true
    key                 = "Env"
    value               = "consul"
  }
}
