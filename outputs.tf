output "boundary_address" {
  value = var.boundary_address
}

output "boundary_auth_string" {
  value = "boundary authenticate password -auth-method-id=${var.boundary_auth_method_id} -login-name=${var.boundary_username} -password=${var.boundary_password}"
}

output "consul_target" {
  value = boundary_target.consul.id
}

output "vault_target" {
  value = boundary_target.vault.id
}

output "nomad_target" {
  value = boundary_target.nomad.id
}

output "postgres_target" {
  value = boundary_target.postgres.id
}


output "ssh_target" {
  value = boundary_target.backend_servers_ssh.id
}

# output "found_ec2_instances" {
#  value = flatten(data.aws_instances.servers.*.private_ips)
# }

# output "found_windows_instances" {
#  value = data.aws_instance.windows.private_ip
# }

# output "found_windows_instance_password" {
#  value = rsadecrypt(data.aws_instance.windows.password_data, file("/Users/guybarros/.ssh/id_rsa"))
# }

# Nomad
output "zz_boundary_connect_nomad" {
  value = "boundary connect -exec chrome -target-id=${boundary_target.nomad.id} -- {{boundary.host}} {{boundary.port}}"
}
# Postgres
output "zz_boundary_connect_postgres" {
  value = "boundary connect postgres -target-id ${boundary_target.postgres.id}  -dbname postgres"
}
# SSh
output "zz_boundary_connect_ssh" {
  value = "boundary connect ssh  -target-id  ${boundary_target.backend_servers_ssh.id} --username ubuntu"
}

output "boundary_worker_tokens" {
  value = boundary_worker.controller_led.*.controller_generated_activation_token
}
