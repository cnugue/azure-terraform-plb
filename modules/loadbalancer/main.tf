resource "azurerm_public_ip" "LoadBalancer_ip" {
    name                = "${var.lb_name}-ip"
    location            = var.location
    resource_group_name = var.rg_name
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm" "PublicLB" {
    name                = var.lb_name
    location            = var.location
    resource_group_name = var.rg_name
    sku                 = "Standard"

    frontend_ip_configuration {
        name                    = "PublicFrontend"
        public_ip_address_id    = azurerm_lb.LoadBalancer_ip.id
    } 
}

resource "azurerm_lb_backend_address_pool" "BackendPool" {
    name                  = "Public-BackendPool"
    loadbalancer_id       =  azurerm_lb.PublicLB.id
}

resource "azurerm_lb_probe" "tcp" {
    name                    = "tcp-probe"
    loadbalancer_id         = azurerm_lb.PublicLB.id
    protocol                = "Tcp"
    port                    = 3389 
}

resource "azurerm_lb_rule" "rdp" {
    name                                = "rdp-rule"
    loadbalancer_id                     = azurerm_lb.PublicLB.id
    protocol                            = "Tcp"
    frontend_port                       = 3389
    backend_port                        = 3389
    frontend_ip_configuration_name      = "PublicFrontEnd"
    backend_address_pool_ids            = [azurerm_lb_backend_address_pool.BackendPool.id]
    probe_id                            = azurerm_lb_probe.tcp.id 
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.bepool.id
}

output "frontend_ip" {
  value = azurerm_public_ip.lb_ip.ip_address
}