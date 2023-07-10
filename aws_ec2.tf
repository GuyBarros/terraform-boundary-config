# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}


data "aws_instances" "servers" {


  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  instance_tags = {
    # owner = var.owner_tag
    Function = "worker"
    Purpose = var.application_name
  }

}

data "aws_instance" "windows" {

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  instance_tags = {
    Function = "Windows"
    Purpose = var.application_name
    #owner = var.owner_tag
  }

  get_password_data = true
}