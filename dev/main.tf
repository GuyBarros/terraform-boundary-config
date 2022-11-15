//--------------------------------------------------------------------
// Variables
variable "config_auth_method_id" {}
variable "config_boundary_address" {}
variable "config_password" {}
variable "config_username" {}
variable "config_vault_address" {}
variable "config_vault_namespace" {}
variable "config_vault_token" {}

//--------------------------------------------------------------------
// Modules
module "config" {
#  source  = "app.terraform.io/emea-se-playground-2019/config/boundary"
 source = "github.com/GuyBarros/terraform-boundary-config"

  application_name = "guystack"
  auth_method_id = var.config_auth_method_id
  boundary_address = var.config_boundary_address
  password = var.config_password
  postgres_password = "YourPwdShouldBeLongAndSecure!"
  sshca_hostname = "workers-0.guystack.original.aws.hashidemos.io"
  username = var.config_username
  vault_address = var.config_vault_address
  vault_namespace = var.config_vault_namespace
  vault_token = var.config_vault_token
  windows_port = 3389
}