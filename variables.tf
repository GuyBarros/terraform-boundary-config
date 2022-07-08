variable "boundary_address" {
  description = "Boundary Host"
  default     = ""
}

variable "auth_method_id" {
  description = "Boundary Auth Method"
  default     = ""
}

variable "username" {
  description = "Boundary Username"
  default     = "admin"
}

variable "password" {
  description = "Boundary Password"
  default     = ""
}


variable "backend_server_ips" {
  type = set(string)
  default = [
    "server-0.eu-guystack.original.aws.hashidemos.io",
    "server-1.eu-guystack.original.aws.hashidemos.io",
    "server-2.eu-guystack.original.aws.hashidemos.io",
  ]
}

# Vault Dynamic DB Cred

//PostgresSQL
variable "postgres_hostname" {
  description = "the hostname of the MySQL Database we will configure in Vault"
}
variable "postgres_port" {
  description = "the port of the MySQL Database we will configure in Vault"
}
variable "postgres_name" {
  description = "the Name of the MySQL Database we will configure in Vault"
}
variable "postgres_username" {
  description = "the admin username of the MySQL Database we will configure in Vault"
}
variable "postgres_password" {
  description = "the password for admin username of the MySQL Database we will configure in Vault(this will be rotated after config)"
}
variable "sshca_public_key"{
 description = "the public key that will be signed by the SSH CA Secret Engine"
}

variable "sshca_hostname"{
  description = "the FQDN for the SSH CA target"
}
variable "windows_hostname" {
  description = "the hostname of the windows VM we will VM into"
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
  default = "admin"
}

 variable "vault_address" {
  description = "the Vault Address"
}

 variable "vault_token" {
  description = "the Vault Address"
  sensitive = true
}

 variable "windows_username" {
  description = "the HCP Vault namespace we will use for mounting the database secret engine"
  default = "Administrator"
}

 variable "windows_password" {
  description = "the HCP Vault namespace we will use for mounting the database secret engine"
  default = "hunter2"
}