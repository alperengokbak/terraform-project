output "public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
  description = "Public IP Address of the VM"
}

output "resource_group_name" {
  value       = azurerm_resource_group.terraform_project.name
  description = "The name of the resource group"
}