

resource "boundary_credential_library_vault" "postgres" {
  name                = "postgres_creds"
  description         = "postgres dynamic creds"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "postgres/creds/postgres-role" # change to Vault backend path
  http_method         = "GET"
}


resource "boundary_host_catalog_static" "postgres_catalog" {
  name        = "postgres_consul_servers"
  description = "Postgres servers host catalog"
  scope_id    = boundary_scope.app_infra.id
}

resource "boundary_host_static" "postgres_host" {
  type            = "static"
  name            = "postgres_server"
  description     = "Postgres server host"
  address         = data.aws_db_instance.postgres.address
  host_catalog_id = boundary_host_catalog_static.postgres_catalog.id
}

resource "boundary_host_set_static" "postgres_set" {
  type            = "static"
  name            = "postgres_set"
  description     = "Host set for postgres servers"
  host_catalog_id = boundary_host_catalog_static.postgres_catalog.id
  host_ids        = [boundary_host_static.postgres_host.id]
}

resource "boundary_target" "postgres" {
  type                     = "tcp"
  name                     = "postgres servers"
  description              = "Postgres target"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = data.aws_db_instance.postgres.port
  session_connection_limit = -1
  egress_worker_filter = " \"demostack\" in \"/tags/type\" "

  host_source_ids = [
    boundary_host_set_static.postgres_set.id
  ]

   brokered_credential_source_ids   = [
    boundary_credential_library_vault.postgres.id
  ]
}

