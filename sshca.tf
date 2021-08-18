
resource "boundary_credential_library_vault" "sshca" {
  name                = "sshca_creds"
  description         = "sshca dynamic creds"
  credential_store_id = boundary_credential_store_vault.demostack_vault.id
  path                = "/ssh-client-signer/sign/my-role/" # change to Vault backend path
  http_method         = "POST"
  http_request_body        = <<EOT
{
  "public_key":${var.public_key},
    "valid_principals": "ubuntu",
    "extensions": {
            "permit-pty": "",
           "permit-port-forwarding": ""
             }
}
EOT
}

resource "boundary_host_catalog" "sshca_catalog" {
  name        = "sshca_consul_servers"
  description = "sshca servers host catalog"
  type        = "static"
  scope_id    = boundary_scope.core_infra.id
}

resource "boundary_host" "sshca_host" {
  type            = "static"
  name            = "sshca_server"
  description     = "sshca server host"
  address         = var.sshca_hostname
  host_catalog_id = boundary_host_catalog.sshca_catalog.id
}

resource "boundary_host_set" "sshca_set" {
  type            = "static"
  name            = "sshca_set"
  description     = "Host set for ssh ca"
  host_catalog_id = boundary_host_catalog.sshca_catalog.id
  host_ids        = [boundary_host.sshca_host.id]
}

resource "boundary_target" "sshca" {
  type                     = "tcp"
  name                     = "sshca servers"
  description              = "sshca target"
  scope_id                 = boundary_scope.core_infra.id
  default_port             = 22
  session_connection_limit = -1

  host_set_ids = [
    boundary_host_set.sshca_set.id
  ]

   application_credential_library_ids = [
    boundary_credential_library_vault.sshca.id
  ]
}