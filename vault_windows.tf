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
    username       = "${var.windows_username}",
    password       = rsadecrypt(data.aws_instance.windows.password_data, file("/Users/guybarros/.ssh/id_rsa"))
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
    username       = "ubuntu",
    public_key       = file("/Users/guybarros/.ssh/id_rsa.pub")
    private_key      = file("/Users/guybarros/.ssh/id_rsa")
  }
  )
}