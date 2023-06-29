resource "vault_mount" "postgres" {
  provider = vault.app
  path     = "postgres"
  type     = "database"
}
resource "vault_database_secret_backend_connection" "postgres-con" {
  provider      = vault.app
  backend       = vault_mount.postgres.path
  name          = "postgres-con"
  allowed_roles = ["postgres-role"]
  postgresql {
    connection_url       = "postgres://${data.aws_db_instance.postgres.master_username}:${var.postgres_password}@${data.aws_db_instance.postgres.endpoint}/${data.aws_db_instance.postgres.db_name}"#?sslmode=disable"
    max_open_connections = -1
  }
}


resource "vault_database_secret_backend_role" "postgres-role" {
  provider            = vault.app
  depends_on          = [vault_database_secret_backend_connection.postgres-con]
  backend             = vault_mount.postgres.path
  name                = "postgres-role"
  db_name             = vault_database_secret_backend_connection.postgres-con.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
  revocation_statements = [
    "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\";",
    "DROP USER \"{{name}}\";",
  ]

}
