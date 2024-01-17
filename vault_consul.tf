provider "consul" {
  address    = var.consul_address
  datacenter = var.consul_datacenter
  token      = var.consul_token
}

resource "consul_acl_policy" "vault-se-policy" {
  name        = "vault-se-policy"
  rules       = <<-RULE
acl = "write"

    namespace_prefix "sandbox" {

acl = "write"

}
    RULE
}

resource "consul_acl_policy" "test-policy" {
  name        = "test-policy"
  namespace   = consul_namespace.sandbox.name
  rules       = <<-RULE
acl = "write"


    RULE
}



resource "consul_namespace" "sandbox" {
  name        = "sandbox"
  description = "sandbox namespace"

  meta = {
    example = "of a meta argument"
  }
}


resource "consul_acl_token" "vault_token" {
  description = "vault token"
  policies = [consul_acl_policy.vault-se-policy.name]
  local = true
}



data "consul_acl_token_secret_id" "token" {
  accessor_id = consul_acl_token.vault_token.id
}

resource "vault_consul_secret_backend" "consul" {
  path        = "consul"
  description = "Manages the Consul backend"

  address = var.consul_address
  token   = data.consul_acl_token_secret_id.token.secret_id
}

resource "vault_consul_secret_backend_role" "example" {
  name    = "test-role"
  backend = vault_consul_secret_backend.consul.path
  consul_namespace = consul_namespace.sandbox.name

  consul_policies = [
    consul_acl_policy.test-policy.name 
  ]
}