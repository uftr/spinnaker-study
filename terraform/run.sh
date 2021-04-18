#!/bin/sh
TERRAFORM_COMMAND="$1"
terraform init
terraform ${TERRAFORM_COMMAND}

# Output the results so we can use it within Spinnaker
# All outputs must be prefixed with SPINNAKER_PROPERTY

echo "SPINNAKER_PROPERTY_PUBLIC_IP=$(terraform output public_ip | tr -d '"')"
