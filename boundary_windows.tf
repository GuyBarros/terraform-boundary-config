

resource "boundary_credential_library_vault" "windows" {
  name                = "windows_creds"
  description         = "windows dynamic creds"
  credential_type     = "username_password"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "boundary_creds/data/windows" # change to Vault backend path
  http_method         = "GET"
}


resource "boundary_host_catalog_static" "windows_catalog" {
  name        = "windows_consul_servers"
  description = "windows servers host catalog"
  scope_id    = boundary_scope.app_infra.id
}

resource "boundary_host_static" "windows_host" {
  type            = "static"
  name            = "windows_server"
  description     = "windows server host"
  address         = data.aws_instance.windows.private_ip
  host_catalog_id = boundary_host_catalog_static.windows_catalog.id
}

resource "boundary_host_set_static" "windows_set" {
  type            = "static"
  name            = "windows_set"
  description     = "Host set for windows servers"
  host_catalog_id = boundary_host_catalog_static.windows_catalog.id
  host_ids        = [boundary_host_static.windows_host.id]
}

resource "boundary_target" "windows" {
  type                     = "tcp"
  name                     = "windows servers"
  description              = "windows target"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = var.windows_port
  session_connection_limit = -1
  egress_worker_filter     = " \"demostack\" in \"/tags/type\" "

  host_source_ids = [
    boundary_host_set_static.windows_set.id
  ]

  brokered_credential_source_ids = [
    boundary_credential_library_vault.windows.id
  ]
}