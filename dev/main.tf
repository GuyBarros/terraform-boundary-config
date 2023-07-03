//--------------------------------------------------------------------
// Variables
variable "config_boundary_auth_method_id" {}
variable "config_boundary_address" {}
variable "config_boundary_password" {}
variable "config_boundary_username" {}
variable "config_vault_address" {}
variable "config_vault_namespace" {}
variable "config_vault_token" {}
variable "config_path_to_private_key" {}
variable "config_path_to_public_key" {}
variable "config_application_name" {}

//--------------------------------------------------------------------
// Modules
module "config" {
#  source  = "app.terraform.io/emea-se-playground-2019/config/boundary"
 source = "github.com/GuyBarros/terraform-boundary-config"

  application_name = var.config_application_name
  boundary_auth_method_id = var.config_boundary_auth_method_id
  boundary_address = var.config_boundary_address
  boundary_password = var.config_boundary_password
  boundary_username = var.config_boundary_username
  postgres_password = "YourPwdShouldBeLongAndSecure!"
  sshca_hostname = "workers-0.guystack.original.aws.hashidemos.io"
  vault_address = var.config_vault_address
  vault_namespace = var.config_vault_namespace
  vault_token = var.config_vault_token
  windows_port = 3389
  path_to_private_key = var.config_path_to_private_key
  path_to_public_key = var.config_path_to_public_key
}