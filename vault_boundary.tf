

resource "vault_token" "boundary" {
  provider     = vault.app
  no_parent    = true
  policies     = [vault_policy.boundary_policy.name, "superadmin", "admin-policy"]
  display_name = "boundary cred store"
  renewable    = true
  period       = "72h"

}

resource "vault_policy" "boundary_policy" {
  provider = vault.app
  name     = "dev-team"


  policy = <<EOT
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  path "kv/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "kv/test/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "pki/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# all access to boundary namespace
path "postgres/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

path "boundary/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

  path "auth/token/revoke-accessor" {
    capabilities = ["read","update"]
  }

  path "auth/token/lookup-self" {
    capabilities = ["read"]
  }
  path "auth/token/lookup" {
    capabilities = ["read","update"]
  }
  path "auth/token/renew-self" {
    capabilities = ["read","update"]
  }
    path "auth/token/revoke-self" {
    capabilities = ["read","update"]
  }
    path "sys/leases/renew" {
    capabilities = ["read","update"]
  }
     path "sys/leases/revoke" {
    capabilities = ["read","update"]
  }

  path "auth/token/revoke-accessor" {
    capabilities = ["read","update"]
  }
  path "/sys/capabilities-self" {
    capabilities =   ["delete", "list", "read", "update"]
  }

  path "/sys/capabilities-accessor" {
     capabilities =  ["delete", "list", "read", "update"]
  }

  path "/sys/capabilities" {
     capabilities =  ["delete", "list", "read", "update"]
  }

  path "auth/token/renew-self" {
    capabilities = ["read","update"]
  }

  path "/postgres/creds/*"{
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

EOT
}

