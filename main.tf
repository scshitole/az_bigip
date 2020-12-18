# Main

# Terraform Version Pinning
terraform {
  required_version = "~> 0.14.0"
  required_providers {
    azurerm = "~> 2.1.0"
  }
}

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.sp_subscription_id
  client_id       = var.sp_client_id
  client_secret   = var.sp_client_secret
  tenant_id       = var.sp_tenant_id
}

# Create a Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}rg"
  location = var.location
}

# Create Log Analytic Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}rg-law"
  sku                 = "PerNode"
  retention_in_days   = 300
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# Create a random id

resource "random_id" id {
  byte_length = 4
}