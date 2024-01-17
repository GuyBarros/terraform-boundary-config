# Grab some information about and from the current AWS account.
data "aws_caller_identity" "current" {}

data "aws_iam_policy" "demo_user_permissions_boundary" {
  name = "DemoUser"
}

locals {
  my_email = split("/", data.aws_caller_identity.current.arn)[2]
}

# Create the user to be used in Boundary for session recording. Then attach the policy to the user.
resource "aws_iam_user" "boundary_session_recording" {
  name                 = "demo-${local.my_email}-bsr"
  permissions_boundary = data.aws_iam_policy.demo_user_permissions_boundary.arn
  force_destroy        = true
}

resource "aws_iam_user_policy_attachment" "boundary_session_recording" {
  user       = aws_iam_user.boundary_session_recording.name
  policy_arn = data.aws_iam_policy.demo_user_permissions_boundary.arn
}

data "aws_iam_policy_document" "boundary_user_policy" {
  statement {
    sid = "InteractWithS3"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectAttributes",
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }
  statement {
    actions = [
      "iam:DeleteAccessKey",
      "iam:GetUser",
      "iam:CreateAccessKey"
    ]
    resources = [aws_iam_user.boundary_session_recording.arn]
  }
}

resource "aws_iam_policy" "boundary_user_policy" {
  name        = "demo-${local.my_email}-bsr-policy"
  path        = "/"
  description = "Managed policy for the Boundary user recorder"
  policy      = data.aws_iam_policy_document.boundary_user_policy.json
}


resource "aws_iam_user_policy_attachment" "boundary_user_policy" {
  user       = aws_iam_user.boundary_session_recording.name
  policy_arn = aws_iam_policy.boundary_user_policy.arn
}

# Generate some secrets to pass in to the Boundary configuration.
# WARNING: These secrets are not encrypted in the state file. Ensure that you do not commit your state file!
resource "aws_iam_access_key" "boundary_session_recording" {
  user       = aws_iam_user.boundary_session_recording.name
  depends_on = [aws_iam_user_policy_attachment.boundary_session_recording]
}

# AWS is eventually-consistent when creating IAM Users. Introduce a wait
# before handing credentails off to boundary.
resource "time_sleep" "boundary_session_recording_user_ready" {
  create_duration = "1m"

  depends_on = [aws_iam_access_key.boundary_session_recording,nomad_job.nomad_boundary_workers]
}

# NOTE:  Be advised, at this time there is no way to delete a storage bucket with the provider or inside of Boundary GUI
# The only way to delete the storage bucket is to delete the cluster at the moment.  As such, you could leverage the below
# to provision a storage bucket with this demo, or you can manage this in your Boundary Cluster Configuration


resource "boundary_storage_bucket" "doormat_example" {
  depends_on = [ nomad_job.nomad_boundary_workers,aws_iam_user.boundary_session_recording,time_sleep.boundary_session_recording_user_ready ]
  name            = "Demo BSR Bucket"
  description     = "Demo Boundary Session Recording Bucket"
  #scope_id        = boundary_scope.app.id
  scope_id        = "global"
  plugin_name     = "aws"
  bucket_name     = var.s3_bucket_name
  attributes_json = jsonencode({ "region" = var.region, "disable_credential_rotation" = var.disable_credential_rotation })

  secrets_json = jsonencode({
    "access_key_id"     = aws_iam_access_key.boundary_session_recording.id,
    "secret_access_key" = aws_iam_access_key.boundary_session_recording.secret
  })
  worker_filter = " \"demostack\" in \"/tags/type\" "
}
