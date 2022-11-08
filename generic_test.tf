
resource "boundary_target" "gen_test" {
  type                     = "tcp"
  name                     = "gen_test"
  description              = "gen_test"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "8500"
  session_connection_limit = -1
  # worker_filter = "demostack in /tags/type"

  host_source_ids = [
    boundary_host_set.backend_servers_ssh.id
  ]
   brokered_credential_source_ids = [
    boundary_credential_library_vault.gen.id
  ]
}

resource "boundary_credential_library_vault" "gen" {
  name                = "gen_vault_token"
  description         = "Credential Library for Vault Token"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "boundary_creds/data/windows" # change to Vault backend path
  http_method         = "GET"
 
  credential_type     = "username_password"
  credential_mapping_overrides = {
    password_attribute = "Password"
    username_attribute = "Username"
  }

}
