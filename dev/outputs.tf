
output "A_Welcome_Message" {
  value = <<EOF

ooooo   ooooo                    oooo         o8o    .oooooo.
`888'   `888'                    `888         `"'   d8P'  `Y8b
 888     888   .oooo.    .oooo.o  888 .oo.   oooo  888           .ooooo.  oooo d8b oo.ooooo.
 888ooooo888  `P  )88b  d88(  "8  888P"Y88b  `888  888          d88' `88b `888""8P  888' `88b
 888     888   .oP"888  `"Y88b.   888   888   888  888          888   888  888      888   888
 888     888  d8(  888  o.  )88b  888   888   888  `88b    ooo  888   888  888      888   888
o888o   o888o `Y888""8o 8""888P' o888o o888o o888o  `Y8bood8P'  `Y8bod8P' d888b     888bod8P'
                                                                                    888
                                                                                   o888o
export BOUNDARY_ADDR=${module.config.boundary_address}

${module.config.boundary_auth_string}
# Consul
boundary connect -target-id=${module.config.consul_target}
# Vault
boundary connect -target-id=${module.config.vault_target}
# Nomad
boundary connect -target-id=${module.config.nomad_target}
# Postgres
boundary connect -target-id=${module.config.postgres_target}


# SSH
boundary connect ssh -target-id=${module.config.ssh_target} -username ubuntu

EOF
}

output "leaf" {
  value = "genertate cert with `vault write pki_int/issue/leaf-cert common_name=demo.example.io`"
}