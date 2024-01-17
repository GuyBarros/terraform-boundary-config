variable "boundary_address" {
  description = "Boundary Host"
  default     = ""
}

variable "boundary_auth_method_id" {
  description = "Boundary Auth Method"
  default     = ""
}

variable "boundary_username" {
  description = "Boundary Username"
  default     = "admin"
}

variable "boundary_password" {
  description = "Boundary Password"
  default     = ""
}


# Vault Dynamic DB Cred

//PostgresSQL

variable "postgres_password" {
  description = "the password for admin username of the MySQL Database we will configure in Vault(this will be rotated after config)"
}



variable "windows_port" {
  description = "the port of the windows VM we will RDP into"
}

################ Vault
variable "application_name" {
  type        = string
  description = "the application identifier which will create github repo, terraform workspace, vault namespace"
}

variable "vault_namespace" {
  description = "the HCP Vault namespace we will use for mounting the database secret engine"
  default     = "admin"
}

variable "vault_address" {
  description = "the Vault Address"
}

variable "vault_token" {
  description = "the Vault Address"
  sensitive   = true
}

variable "windows_username" {
  description = "the HCP Vault namespace we will use for mounting the database secret engine"
  default     = "Administrator"
}

variable "path_to_private_key" {
  description = "path to the private key used on your Windows EC2 host"
}

variable "path_to_public_key" {
  description = "path to the private key used on your Windows EC2 host"
}


variable "owner_tag" {
  description = "Owner in the AWS tags to find resources in the account"
  default     = "guybarros"
}


variable "nomad_address" {
  description = "nomad address to run the vault ssh config job"
  default     = "https://nomad.guylabstack.guy.aws.sbx.hashicorpdemo.com:4646"
}

variable "nomad_token" {
  description = "nomad acl secret id  to run the vault ssh config job"
  sensitive   = true
}

variable "boundary_ingress_worker_count" {
  description = "count of ingress workers do deploy on nomad"
  default     = 3
}


variable "disable_credential_rotation" {
  type        = bool
  description = "Bool to signal if Boundary should not rotate the IAM Access Credentials"
  default     = true
}



variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "consul_datacenter" {
  type        = string
  description = "HCP Consul Datacenter Name"
  default     = "eu-west-2"
}

variable "consul_address" {
  type        = string
  description = "HCP Consul Address"
}

variable "consul_token" {
  type        = string
  description = "HCP Consul Token"
  sensitive = true
}


variable "okta_org_name" {
  type        = string
  description = "The org name, ie for dev environments `dev-123456`"
}

variable "okta_base_url" {
  type        = string
  description = "The Okta SaaS endpoint, usually okta.com or oktapreview.com"
}

variable "okta_base_url_full" {
  type        = string
  description = "Full URL of Okta login, usually instanceID.okta.com, ie https://dev-208447.okta.com"
}

variable "okta_issue_mode" {
  type        = string
  description = "Indicates whether the Okta Authorization Server uses the original Okta org domain URL or a custom domain URL as the issuer of ID token for this client. ORG_URL = foo.okta.com, CUSTOM_URL = custom domain"
  default     = "ORG_URL"
}

variable "okta_api_token" {
  type        = string
  description = "Okta API key"
}

variable "okta_allowed_groups" {
  type        = list(any)
  description = "Okta group for Vault admins"
  default     = ["vault_admins"]
}

variable "okta_mount_path" {
  type        = string
  description = "Mount path for Okta auth"
  default     = "okta_oidc"
}

variable "okta_user_email" {
  type        = string
  description = "e-mail of a user to dynamically add to the groups created by this config"
}

variable "okta_tile_app_label" {
  type        = string
  description = "HCP Vault"
}

# variable "okta_client_id" {
#   type        = string
#   description = "Okta Vault app client ID"
# }

# variable "okta_client_secret" {
#   type        = string
#   description = "Okta Vault app client secret"
# }

# variable "okta_bound_audiences" {
#   type        = list(any)
#   description = "A list of allowed token audiences"
# }

variable "okta_auth_audience" {
  type        = string
  description = ""
  default     = "api://vault"
}


variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "boundary-s3-bucket"
}

variable "s3_bucket_name_tags" {
  type        = string
  description = "Name tag to associate to the S3 Bucket"
  default     = "Session-Recording"
}

variable "s3_bucket_env_tags" {
  type        = string
  description = "Environment tag to associate to the S3 Bucket"
  default     = "Boundary"
}
