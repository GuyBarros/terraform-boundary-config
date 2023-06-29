resource "vault_mount" "ssh_mount" {
    provider      = vault.app
  path        = "ssh-client-signer"
  type        = "ssh"
  description = "SSH Mount"
}

resource "vault_ssh_secret_backend_ca" "ssh_backend" {
    provider      = vault.app
  backend              = vault_mount.ssh_mount.path
  public_key  = file(var.path_to_public_key)
      private_key = file(var.path_to_private_key)
  
}

resource "vault_ssh_secret_backend_role" "ssh_role" {
    provider      = vault.app
  name                    = "boundary-client"
  backend                 = vault_mount.ssh_mount.path
  key_type                = "ca"
  allow_host_certificates = true
  allow_user_certificates = true
  default_user            = "ubuntu"
  ttl                     = "2m0s"
  default_extensions = {
    permit-pty = ""
  }
  allowed_users      = "*"
  allowed_extensions = "*"
}
