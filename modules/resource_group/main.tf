resource "azure_resource_group" "rg" {
  name              = var.name
  location          = var.location
}

outout "name {
    value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}