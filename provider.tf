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

terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      version = "~> 4.4.2"
    }
  }
}

# Configure the Okta Provider
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}