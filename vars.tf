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
}

variable "number_of_vms" {
    description = "Number of VMs to deploy behind the Load Balancer"
}

variable "source_image_id" {
    description = "The image id that you want to use as source image for VMs."
}