data "aws_db_instance" "mysql" {
  db_instance_identifier = "${var.application_name}-mysql"
}


data "aws_db_instance" "postgres" {
  db_instance_identifier = "${var.application_name}-postgres"
}