///////////////// Vault Namespace

provider "vault" {
  address = var.vault_address
  # namespace = var.vault_namespace
  token = var.vault_token
}


provider "vault" {
  alias     = "app"
  address   = var.vault_address
  namespace = trimsuffix(vault_namespace.app.id, "/")
  token     = var.vault_token
}

resource "vault_namespace" "app" {
  path = var.application_name
}
