resource "vault_mount" "boundary_creds" {
    provider = vault.app
  path        = "boundary_creds"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}


resource "time_sleep" "wait_5_seconds" {
  depends_on = [vault_mount.boundary_creds]

  create_duration = "5s"
}

resource "vault_kv_secret_v2" "windows" {
    depends_on = [time_sleep.wait_5_seconds]
    provider = vault.app
  mount                      = vault_mount.boundary_creds.path
  name                       = "windows"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    Username       = "${var.windows_username}",
    Password       = "${var.windows_password}"
  }
  )
}


resource "vault_kv_secret_v2" "ssh" {
    depends_on = [time_sleep.wait_5_seconds]
    provider = vault.app
  mount                      = vault_mount.boundary_creds.path
  name                       = "ssh"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    Username       = "ubuntu",
    Public_key       = "${var.sshca_public_key}"
  }
  )
}