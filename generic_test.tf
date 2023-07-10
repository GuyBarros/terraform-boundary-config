
resource "boundary_target" "gen_test" {
  type                     = "ssh"
  name                     = "gen_test_ssh_injected"
  description              = "gen_test"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "22"
  session_connection_limit = -1
  egress_worker_filter     = " \"demostack\" in \"/tags/type\" "

  host_source_ids = [
    boundary_host_set_static.backend_servers_ssh.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_library_vault_ssh_certificate.vault_ssh_cert.id
  ]

}

# resource "boundary_credential_library_vault" "gen" {
#   name                = "gen_vault_token"
#   description         = "Credential Library for Vault Token"
#   credential_store_id = boundary_credential_store_vault.app_vault.id
#   path                = "boundary_creds/data/ssh" # change to Vault backend path
#   http_method         = "GET"

#   credential_type = "ssh_private_key"
#  # credential_mapping_overrides = {
#  #   password_attribute = "password"
#  #   username_attribute = "username"
#  # }

# }

resource "boundary_credential_library_vault_ssh_certificate" "vault_ssh_cert" {
  name                = "ssh-certs"
  description         = "Vault SSH Cert Library"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "ssh-client-signer/sign/boundary-client" # change to correct Vault endpoint and role
  username            = "ubuntu"                                 # change to valid username
}