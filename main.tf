terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.100"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
    location            = "East US"
    resource_group      = "PublicLB"
    vnet_name           = "Public-Demo-VNet"
    subnet_name         = "Public-Demo-Subnet"
    lb_name             = "Public-LB-Demo"
    vm_size             = "Standard_B2s"
    admin_username      = "azureuser"
    admin_password      = "Password1234!"
}

module "rg" {
    source              = "./modules/resource_group"
    name                = local.resource_group
    location            = local.location
}

module "network" {
    source              = "./modules/network"
    rg_name             = module.rg.name
    location            = module.rg.location
    vnet_name           = local.vnet_name
    subnet_name         = local.subnet_name
}

module "lb" {
    source              = "./modules/loadbalancer"
    rg_name             = module.rg.name
    location            = module.rg.location
    lb_name             = local.lb_name
    subnet_id           = module.network.subnet_id
}

module "vm" {
    source              = "./modules/vm"
    rg_name             = module.rg.name
    location            = module.rg.location
    subnet_id           = module.network.subnet_id
    lb_backend_pool     = module.lb.backend_pool_id
    vm_size             = local.vm_size
    admin_username      = local.admin_username
    admin_password      = local.admin_password
}