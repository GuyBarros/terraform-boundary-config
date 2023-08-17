resource "boundary_worker" "controller_led" {
  count       = var.boundary_ingress_worker_count
  scope_id    = "global"
  name        = "${var.application_name} ingress worker ${count.index}"
  description = "self managed worker with controller led auth"
}

resource "nomad_job" "nomad_boundary_workers" {
  count = var.boundary_ingress_worker_count
  hcl2 {
    enabled = true
    vars = {
      boundary_auth_token = boundary_worker.controller_led[count.index].controller_generated_activation_token
      #boundary_auth_token = boundary_worker.controller_led[0].controller_generated_activation_token
      boundary_ingress_worker_count = var.boundary_ingress_worker_count
      hcp_boundary_cluster_id       = substr(var.boundary_address, 8, 36)
    }
  }
  jobspec = <<EOT

variable "boundary_version" {
  type = string
  default = "0.13.2+ent"
}

variable "boundary_checksum" {
  type = string
  default = "dda11361809ce2b99d49653af677d676b30b4599e2663174f8950cf346734be0"

}

variable "boundary_auth_token" {
  default = ""
  
}

variable "boundary_ingress_worker_count"{
  type = number
  default = 3
}

variable "hcp_boundary_cluster_id"{
  type = string
  default = ""
}


job "boundary-ingress-worker-${count.index}" {
 region = "global"
  datacenters = ["eu-west-2a","eu-west-2b","eu-west-2c","eu-west-2","dc1"]
  type = "service"

  group "boundary-worker" {
    count = 1

      constraint {
        operator = "distinct_hosts"
        value = "true"
      }
    network {
          port  "worker"  {
            static = 9202
          }
        }
    task "boundary-ingress-worker.service" {
      driver = "raw_exec"

      resources {
        cpu = 2000
        memory = 1024

      }
      artifact {
         source     = "https://releases.hashicorp.com/boundary/$${var.boundary_version}/boundary_$${var.boundary_version}_linux_amd64.zip"
        destination = "./tmp/"
        options {
          # checksum = "sha256:$${var.boundary_checksum}"
        }
      }

      env {
        AWS_ACCESS_KEY_ID     = aws_iam_access_key.boundary_session_recording.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.boundary_session_recording.secret
      }

      template {
        data        = <<EOF
        disable_mlock = true
 
 hcp_boundary_cluster_id = "$${var.hcp_boundary_cluster_id}"

 listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
     tls_disable = true
 }
 


 worker {
  auth_storage_path = "tmp/boundary.d/"
  recording_storage_path = "tmp/boundary.d/"
  # change this to the public ip address of the specific platform you are running or use "attr.unique.network.ip-address"
   public_addr = "{{ env "attr.unique.platform.aws.public-ipv4" }}"

    
    
     tags {
    type      = ["workers","ent","demostack","ingress"]
  }
   controller_generated_activation_token = "$${var.boundary_auth_token}"
 }
 
 events {
  audit_enabled       = true
  sysevents_enabled   = true
  observations_enable = true
  sink "stderr" {
    name = "all-events"
    description = "All events sent to stderr"
    event_types = ["*"]
    format = "cloudevents-json"
  }
  sink {
    name = "file-sink"
    description = "All events sent to a file"
    event_types = ["*"]
    format = "cloudevents-json"
    file {
      path = "/var/log/boundary"
      file_name = "egress-worker.log"
    }
    audit_config {
      audit_filter_overrides {
        sensitive = "redact"
        secret    = "redact"
      }
    }
  }
 }

        EOF
        destination = "./tmp/boundary.d/pki-worker.hcl"
      }
      config {
        command = "/tmp/boundary"
        args = ["server", "-config=tmp/boundary.d/pki-worker.hcl"]
      }
      service {
        name = "$${NOMAD_JOB_NAME}"
        address = "$${attr.unique.platform.aws.public-ipv4}"
        tags = ["boundary-ingress-worker","worker-$${NOMAD_JOB_NAME}"]
        port = "worker"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

  }

  update {
    max_parallel = 1
    min_healthy_time = "5s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
}

EOT
}