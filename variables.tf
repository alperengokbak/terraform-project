variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default = "6b2e6a6f-5a58-4c44-8227-8b8c21cc07ae"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "West Europe"  
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "alperengokbak"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/azure_key.pub"
}