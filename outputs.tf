output "resource_group_name" {
  value = module.rg.name
}

output "public_lb_ip" {
  value = module.lb.frontend_ip
}

output "vm_private_ips" {
  value = module.vm.private_ips
}