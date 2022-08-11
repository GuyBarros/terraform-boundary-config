# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}


data "aws_instances" "servers" {

 instance_tags = {
    owner = "guybarros"
function = "server"
  }

}

data "aws_instance" "windows" {

instance_tags = {
    owner = "guybarros"
function = "Windows"
  }

get_password_data = true
}