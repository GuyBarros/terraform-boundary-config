resource "boundary_auth_method_oidc" "provider" {
  name                 = "Okta"
  description          = "OIDC auth method for Okta"
  scope_id             = "global"
  issuer               = okta_auth_server.boundary.issuer
  client_id            = okta_app_oauth.boundary.client_id
  client_secret        = okta_app_oauth.boundary.client_secret
  signing_algorithms   = ["RS256"]
  api_url_prefix       = var.boundary_address
  is_primary_for_scope = true
  state                = "active-public"
  max_age              = 0
}

resource "boundary_account_oidc" "oidc_user" {
  name           = "guy-hashicorp"
  description    = "OIDC account for guy-HashiCorp"
  auth_method_id = boundary_auth_method_oidc.provider.id
  issuer         = okta_auth_server.boundary.issuer
  subject        = okta_app_oauth.boundary.client_id
}

resource "boundary_managed_group" "oidc_managed_group" {
  name           = "okta-managed-group"
  description    = "Okta Managed Group"
  auth_method_id = boundary_auth_method_oidc.provider.id
  filter         = "\"okta.com\" in \"/token/iss\""
}

resource "boundary_role" "oidc_admin_role" {
  name          = "Admin Role"
  description   = "admin role"
  principal_ids = [boundary_managed_group.oidc_managed_group.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = "global"
}


resource "boundary_role" "oidc_user_role" {
  name          = "User Role"
  description   = "user role org"
  principal_ids = [boundary_managed_group.oidc_managed_group.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.app.id
}



resource "boundary_role" "oidc_user_role_project" {
  name          = "User Role"
  description   = "user role project"
  principal_ids = [boundary_managed_group.oidc_managed_group.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.app_infra.id
}
