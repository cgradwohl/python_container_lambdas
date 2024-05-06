#!/bin/bash

# Set the directory where your Terraform configuration files are located
TERRAFORM_DIR="terraform_backend/dev"

# Navigate to the Terraform directory
cd $TERRAFORM_DIR

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

if [ $? -eq 0 ]; then
    echo "Terraform initialized successfully."
else
    echo "Failed to initialize Terraform." 1>&2
    exit 1
fi

# Apply Terraform configuration
echo "Applying Terraform configuration for the development environment..."
terraform apply -var-file="dev.tfvars" -auto-approve

if [ $? -eq 0 ]; then
    echo "Terraform configuration applied successfully."
else
    echo "Failed to apply Terraform configuration." 1>&2
    exit 1
fi
