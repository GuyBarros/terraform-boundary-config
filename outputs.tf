
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
export BOUNDARY_ADDR=${var.boundary_address}

boundary authenticate password -auth-method-id=${var.auth_method_id} -login-name=${var.username} -password=${var.password}
# Consul
boundary connect -target-id=${boundary_target.consul.id}
# Vault
boundary connect -target-id=${boundary_target.vault.id}
# Nomad
boundary connect -target-id=${boundary_target.nomad.id}

# SSH
boundary connect ssh -target-id=${boundary_target.backend_servers_ssh.id} -username ubuntu

EOF
}

output "found_ec2_instances" {
   value = flatten(data.aws_instances.servers.*.private_ips)
   }

   output "found_windows_instances" {
   value = data.aws_instance.windows.private_ip
   }

    output "found_windows_instance_password" {
   value = rsadecrypt(data.aws_instance.windows.password_data, file("/Users/guybarros/.ssh/id_rsa"))
   }