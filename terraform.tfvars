boundary_address           = "http://boundary.guystack1.original.aws.hashidemos.io:9200/"
auth_method_id = "ampw_ITRp55bFMa"
username       = "admin"
password       = "ERaHGOIuhP7jsQKjvrfB"
backend_server_ips = [
  "ip-10-1-1-81.eu-west-2.compute.internal",
  "ip-10-1-2-244.eu-west-2.compute.internal",
  "ip-10-1-3-87.eu-west-2.compute.internal",
]
vault_address    = "https://vault.guystack1.original.aws.hashidemos.io:8200"
vault_token   = "hvs.3T0Fs0KXELcNbYjFvgA5qh5l"
vault_namespace = "boundary"

#"postgresql://root:rootpassword@boundary-postgres.service.consul:5432/boundary?sslmode=disable"
postgres_hostname = "boundary-postgres.service.consul"
postgres_port = 5432
postgres_name = "boundary"
postgres_username ="root"
postgres_password ="rootpassword"

sshca_hostname = "server-1.guystack1.original.aws.hashidemos.io"

application_name = "demostack"
windows_port = 3389
