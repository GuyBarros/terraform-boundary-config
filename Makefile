all: login init demostack apply
.PHONY: all doormat_creds doormat_aws deploy destroy console
TFC_ORG = emea-se-playground-2019
WORKSPACE_DEMOSTACK = Guy-AWS-Demostack
DOORMAT_AWS_ACCOUNT = aws_guy_test
login:
	doormat login
init:
	terraform init
demostack:
	doormat aws export --account $(DOORMAT_AWS_ACCOUNT)
apply:
	terraform init
	terraform plan
	terraform apply
destroy:
	terraform destroy