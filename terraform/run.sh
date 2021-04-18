#!/bin/sh
terraform init
terraform apply -auto-approve

# Output the results so we can use it within Spinnaker
# All outputs must be prefixed with SPINNAKER_PROPERTY

echo "SPINNAKER_PROPERTY_PUBLIC_IP=$(terraform output public_ip | tr -d '"')"
