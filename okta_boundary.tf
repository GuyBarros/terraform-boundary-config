# Okta config
resource "okta_group" "boundary-admins" {
  name        = "boundary-admins"
  description = "Group for boundary Admins"
}

resource "okta_group" "boundary-devs" {
  name        = "boundary-devs"
  description = "Group for Developers to use boundary"
}

resource "okta_app_oauth" "boundary" {
  label       = var.okta_tile_app_label
  type        = "web"
  grant_types = ["authorization_code", "implicit", "refresh_token"]
  redirect_uris = ["${var.boundary_address}/v1/auth-methods/oidc:authenticate:callback"
  ]
  response_types            = ["id_token", "code"]
  consent_method            = "REQUIRED"
  post_logout_redirect_uris = [var.boundary_address]
  login_uri                 = "${var.boundary_address}"
  refresh_token_rotation    = "STATIC"
  lifecycle {
    ignore_changes = [groups_claim]
  }
  groups_claim {
    type        = "FILTER"
    filter_type = "STARTS_WITH"
    name        = "groups"
    value       = "boundary"
  }
  login_mode   = "SPEC"
  login_scopes = ["openid", "email", "profile"]
  hide_web     = false
  hide_ios     = false
}

resource "okta_app_oauth_api_scope" "boundary" {
  app_id = okta_app_oauth.boundary.id
  issuer = var.okta_base_url_full
  scopes = ["okta.groups.read", "okta.users.read.self"]
}

resource "okta_app_group_assignments" "boundary-groups" {
  app_id = okta_app_oauth.boundary.id
  group {
    id = okta_group.boundary-admins.id
  }
  group {
    id = okta_group.boundary-devs.id
  }
}

resource "okta_auth_server" "boundary" {
  audiences   = [var.okta_auth_audience]
  description = ""
  name        = "boundary"
  issuer_mode = var.okta_issue_mode
  status      = "ACTIVE"
}

resource "okta_auth_server_claim" "example" {
  auth_server_id          = okta_auth_server.boundary.id
  name                    = "groups"
  value_type              = "GROUPS"
  group_filter_type       = "STARTS_WITH"
  value                   = "boundary-"
  scopes                  = ["profile"]
  claim_type              = "IDENTITY"
  always_include_in_token = true
}

resource "okta_auth_server_policy" "boundary" {
  auth_server_id   = okta_auth_server.boundary.id
  status           = "ACTIVE"
  name             = "boundary policy"
  description      = ""
  priority         = 1
  client_whitelist = ["ALL_CLIENTS"]
}

resource "okta_auth_server_policy_rule" "example" {
  auth_server_id       = okta_auth_server.boundary.id
  policy_id            = okta_auth_server_policy.boundary.id
  status               = "ACTIVE"
  name                 = "default"
  priority             = 1
  group_whitelist      = ["EVERYONE"]
  scope_whitelist      = ["*"]
  grant_type_whitelist = ["client_credentials", "authorization_code", "implicit"]
}

# Add user to groups
data "okta_user" "example" {
  search {
    name  = "profile.email"
    value = var.okta_user_email
  }
}

resource "okta_user_group_memberships" "example" {
  user_id = data.okta_user.example.id
  groups = [
    okta_group.boundary-admins.id,
    okta_group.boundary-devs.id,
  ]
}

