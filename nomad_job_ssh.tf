provider "nomad" {
  address   = var.nomad_address
  secret_id = var.nomad_token
}

resource "nomad_job" "nomad_vault_config" {
  depends_on = [vault_ssh_secret_backend_role.ssh_role]
  jobspec    = <<EOT

job "boundary_vault_ssh_config" {
  region = "global"
  datacenters = ["eu-west-2a","eu-west-2b","eu-west-2c","eu-west-2"]
  type = "batch"

  group "workers_to_config"{
  count = 3 


/*
  vault {
    policies = ["superuser"]
    change_mode   = "restart"
    namespace = "=admin/guystack"
  }
*/
   constraint {
      operator  = "distinct_hosts"
      value     = "true"
    }

  task "vault_ssh_ca_install" {
    
    driver = "raw_exec"

    template {
      data = <<EOH
set -v

export VAULT_ADDR=${var.vault_address}
export VAULT_NAMESPACE=${trimsuffix(vault_namespace.app.id, "/")}
export VAULT_TOKEN=${var.vault_token}

vault version

# Add the public key to all target host's SSH configuration
vault read -field=public_key ${vault_mount.ssh_mount.path}/config/ca > /etc/ssh/trusted-user-ca-keys.pem

# Setting up /etc/ssh/sshd_config
grep -qxF 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' /etc/ssh/sshd_config || sudo echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' >> /etc/ssh/sshd_config

# This is what your sshd config looks like now:
cat /etc/ssh/sshd_config

# restarting SSHD
sudo systemctl restart sshd

# remove your authorised_keys, if any.
if [ -f /home/ubuntu/.ssh/authorized_keys ]; then
  mv /home/ubuntu/.ssh/authorized_keys /home/ubuntu/.ssh/backup
fi

# Uncomment the line below if you run into issues
# mv /home/ubuntu/.ssh/backup /home/ubuntu/.ssh/authorized_keys

exit 0
EOH

      destination = "script.sh"
      perms = "755"
    }

    config {
      command = "bash"
      args    = ["script.sh"]
    }
  }

 }#Group
} # Job




EOT
}