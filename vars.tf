variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "testing"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "east us"
}

variable "tags" {
  description = "Default Tags"
  default = {
        environment = "dev"
        department = "IT"
  }
}

variable "admin_password" {
    description = "Password for admin"
}

variable "admin_user" {
    description = "Admin User Name"
    default = "admuser"
}

variable "number_of_vms" {
    description = "Number of VMs to deploy behind the Load Balancer"
    default = 2
}

variable "source_image_id" {
    description = "The image id that you want to use as source image for VMs."
    default = "/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/packer-rg/providers/Microsoft.Compute/images/myPackerImage"
}