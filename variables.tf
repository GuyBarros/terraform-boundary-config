variable "addr" {
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

variable "users" {
  type = set(string)
  default = [
    "Jim",
    "Mike",
    "Todd",
    "Jeff",
    "Randy",
    "Susmitha"
  ]
}

variable "readonly_users" {
  type = set(string)
  default = [
    "Chris",
    "Pete",
    "Justin"
  ]
}

variable "backend_server_ips" {
  type = set(string)
  default = [
    "server-0.eu-guystack.original.aws.hashidemos.io",
    "server-1.eu-guystack.original.aws.hashidemos.io",
    "server-2.eu-guystack.original.aws.hashidemos.io",
  ]
}
# Vault
variable "vault_addr" {
  description = "Vault Address to be used for the Credential library"
  default     = "https://vault.guystack1.original.aws.hashidemos.io:8200"
}

variable "vault_token" {
  description = "Token to access vault for Cred Library"
}

variable "vault_namespace" {
  description = "Namespace for the Cred library"
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
