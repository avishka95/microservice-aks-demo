#!/bin/bash

# Colour schema for logs
RED='\033[01;31m'
GREEN='\033[01;32m'
DEFAULT='\033[00m'
BOLD='\033[1m'
YELLOW='\033[0;33m'

command -v terraform >/dev/null 2>&1 || {
    echo -e >&2 "${RED}Terraform cannot be found. Follow https://learn.hashicorp.com/terraform/getting-started/install.html to install Terraform."
    echo -e >&2 "Aborting...${DEFAULT}"
    exit
}
command -v az >/dev/null 2>&1 || {
    echo -e >&2 "${RED}AZ CLI cannot be found. Follow https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest."
    echo -e >&2 "Aborting...${DEFAULT}"
    exit
}

# Reading values related to azurerm backend for terraform
backend_storage_account_name="cwtfstate2123"
backend_container_name="tfstate"
key="cw.terraform.tfstate"
backend_key="wDnJ/Cj9j8Lz2ejXaMsRVhBd+gIs+oG8gGpdmJ0MLlVH9MgW1+BVh/3brKhyL9J0+Cg3Ehl0CC5KUyP5ZWwwjQ=="

export ARM_ACCESS_KEY=${backend_key}
export TF_VAR_client_id=77171345-c4ac-4430-910d-643ba8492edc
export TF_VAR_client_secret=r817Q~IhnfDto.f_fe4gNUV6xLsdyF~Qk_o1R

# Go to directory where Terraform deployment is
cd deployment

echo -e "${BOLD}Getting any updates for terraform modules...${DEFAULT}"
terraform get -update

echo -e "${BOLD}Initializing Terraform remote backend...${DEFAULT}"
terraform init -backend-config="storage_account_name=${backend_storage_account_name}" \
                  -backend-config="container_name=${backend_container_name}" \
                  -backend-config="key=${key}"
tf_init_ec=$?
echo

   # Cannot continue without the backend being initialized
if [ $tf_init_ec != 0 ]; then
    echo -e "${RED}Backend initialization failed.${DEFAULT}"
    echo "\`terraform init\` exit code $tf_init_ec"
    exit
fi

echo
echo -e "${BOLD}Validating Terraform scripts files.${DEFAULT}"
terraform validate
tf_validate_ec=$?

# Cannot continue if validation fails
if [ $tf_validate_ec != 0 ]; then
    echo -e "${RED}Terraform script validation failed.${DEFAULT}"
    echo "\`terraform validation\` exit code $tf_validate_ec"
    exit
fi

echo
echo -e "${YELLOW}Formatting Terraform source files.${DEFAULT}"
terraform fmt

echo
terraform apply
tf_apply_ec=$?

if [ $tf_apply_ec != 0 ]; then
      echo -e "${RED}Environment creation failed.${DEFAULT}"
      echo "\`terraform apply\` exit code $tf_apply_ec"
      exit
fi
popd > /dev/null 2>&1 || exit

unset ARM_ACCESS_KEY
