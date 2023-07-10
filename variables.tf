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

