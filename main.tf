provider "boundary" {
  addr                            = var.boundary_address
  auth_method_id                  = var.boundary_auth_method_id
  password_auth_method_login_name = var.boundary_username
  password_auth_method_password   = var.boundary_password
}


resource "boundary_scope" "app" {
  name                     = var.application_name
  description              = "scope for ${var.application_name}"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "app_infra" {
  name                     = "${var.application_name}_infrastrcture"
  description              = "${var.application_name} project!"
  scope_id                 = boundary_scope.app.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_host_catalog_static" "backend_servers" {
  name        = "backend_servers"
  description = "Backend servers host catalog"
  scope_id    = boundary_scope.app_infra.id
}

resource "boundary_host_static" "backend_servers" {
  for_each        = toset(data.aws_instances.servers.private_ips)
  type            = "static"
  name            = "backend_server_service_${each.value}"
  description     = "Backend server host"
  address         = each.key
  host_catalog_id = boundary_host_catalog_static.backend_servers.id
}

resource "boundary_host_set_static" "backend_servers_ssh" {
  type            = "static"
  name            = "backend_servers_ssh"
  description     = "Host set for backend servers"
  host_catalog_id = boundary_host_catalog_static.backend_servers.id
  host_ids        = [for host in boundary_host_static.backend_servers : host.id]
}


resource "boundary_target" "nomad" {
  type                     = "tcp"
  name                     = "nomad"
  description              = "nomad servers"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "4646"
  session_connection_limit = -1
  egress_worker_filter     = " \"demostack\" in \"/tags/type\" "

  host_source_ids = [
    boundary_host_set_static.backend_servers_ssh.id
  ]
}

resource "boundary_target" "consul" {
  type                     = "tcp"
  name                     = "consul"
  description              = "consul servers"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "8500"
  session_connection_limit = -1
  egress_worker_filter     = " \"demostack\" in \"/tags/type\" "

  host_source_ids = [
    boundary_host_set_static.backend_servers_ssh.id
  ]
}

resource "boundary_target" "vault" {
  type                     = "tcp"
  name                     = "vault"
  description              = "vault servers"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "8200"
  session_connection_limit = -1
  egress_worker_filter     = " \"demostack\" in \"/tags/type\" "

  host_source_ids = [
    boundary_host_set_static.backend_servers_ssh.id
  ]
}

# create target for accessing backend servers on port :22
resource "boundary_target" "backend_servers_ssh" {
  type                     = "tcp"
  name                     = "Backend servers"
  description              = "Backend SSH target"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "22"
  session_connection_limit = -1
  egress_worker_filter     = " \"demostack\" in \"/tags/type\" "
  host_source_ids = [
    boundary_host_set_static.backend_servers_ssh.id
  ]
  # brokered_credential_source_ids   = [
  #  boundary_credential_library_vault.ssh.id
  # ]


}

resource "boundary_credential_store_vault" "app_vault" {
  name        = "appHCP_Vault"
  description = "app Vault Credential Store"
  # address     = "https://vault.service.consul:8200"
  address = var.vault_address
  token   = vault_token.boundary.client_token
  # token       = var.vault_token
  namespace = "admin/${var.application_name}"
  scope_id  = boundary_scope.app_infra.id
}

resource "boundary_credential_library_vault" "ssh" {
  name                = "vault_token"
  description         = "Credential Library for Vault Token"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "boundary_creds/data/ssh" # change to Vault backend path
  http_method         = "GET"
}
