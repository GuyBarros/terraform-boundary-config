boundary_address           = "https://d53200bb-7d95-4413-bd5c-63a95fc28c53.boundary.hashicorp.cloud"
auth_method_id = "ampw_mFNVNJ4KSq"
username       = "admin"
password       = "Welcome1"

vault_address    = "https://guystack-vault-public-vault-d141f84e.f671c78f.z1.hashicorp.cloud:8200"
vault_token   = "hvs.CAESILClXkPveR12pC3KRVb2tIMsjkf8vZYH6-KZrfiQuCv-GicKImh2cy5pcGtMeXNpTzFPODJZVGd1RTVITHAxU3QuWlBBU3QQiwY"
vault_namespace = "boundary"

#"postgresql://root:rootpassword@boundary-postgres.service.consul:5432/boundary?sslmode=disable"
postgres_hostname = "boundary-postgres.service.consul"
postgres_port = 5432
postgres_name = "boundary"
postgres_username ="root"
postgres_password ="rootpassword"

sshca_hostname = "workers-0.guystack.original.aws.hashidemos.io"

application_name = "guystack"
windows_port = 3389
