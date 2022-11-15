output "boundary_address" {
 value = var.boundary_address
}

output "boundary_auth_string" {
 value = "boundary authenticate password -auth-method-id=${var.auth_method_id} -login-name=${var.username} -password=${var.password}"
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
