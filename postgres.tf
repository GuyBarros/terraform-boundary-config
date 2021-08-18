

resource "boundary_credential_library_vault" "postgres" {
  name                = "postgres_creds"
  description         = "postgres dynamic creds"
  credential_store_id = boundary_credential_store_vault.demostack_vault.id
  path                = "postgres/creds/postgres-role/" # change to Vault backend path
  http_method         = "GET"
}


resource "boundary_host_catalog" "postgres_catalog" {
  name        = "postgres_consul_servers"
  description = "Postgres servers host catalog"
  type        = "static"
  scope_id    = boundary_scope.core_infra.id
}

resource "boundary_host" "postgres_host" {
  type            = "static"
  name            = "postgres_server"
  description     = "Postgres server host"
  address         = var.postgres_hostname
  host_catalog_id = boundary_host_catalog.postgres_catalog.id
}

resource "boundary_host_set" "postgres_set" {
  type            = "static"
  name            = "postgres_set"
  description     = "Host set for postgres servers"
  host_catalog_id = boundary_host_catalog.postgres_catalog.id
  host_ids        = [boundary_host.postgres_host.id]
}

resource "boundary_target" "postgres" {
  type                     = "tcp"
  name                     = "postgres servers"
  description              = "Postgres target"
  scope_id                 = boundary_scope.core_infra.id
  default_port             = var.postgres_port
  session_connection_limit = -1

  host_set_ids = [
    boundary_host_set.postgres_set.id
  ]

   application_credential_library_ids = [
    boundary_credential_library_vault.postgres.id
  ]
}
