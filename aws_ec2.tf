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
    owner = "guybarros"
    #function = "server"
  }

}

data "aws_instance" "windows" {

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  instance_tags = {
    owner    = "guybarros"
    function = "Windows"
  }

  get_password_data = true
}