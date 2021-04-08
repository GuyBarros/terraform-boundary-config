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
