#!/bin/bash

# Set the directory where your Terraform configuration files are located
TERRAFORM_BACKEND_DIR="terraform_backend/dev"

# Navigate to the Terraform Backend directory
cd $TERRAFORM_BACKEND_DIR

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
terraform apply -auto-approve

if [ $? -eq 0 ]; then
    echo "Terraform configuration applied successfully."
else
    echo "Failed to apply Terraform configuration." 1>&2
    exit 1
fi

# Retrieve the output of the S3 bucket name
BUCKET_NAME=$(terraform output -raw terraform_state_bucket_name)

# Check if the output command succeeded and the bucket name is not empty
if [ $? -eq 0 ] && [ -n "$BUCKET_NAME" ]; then
    echo "Retrieved bucket name: $BUCKET_NAME"
    
    # Specify the correct path to dev.tfvars
    TFVARS_PATH="../../terraform/environments/dev.tfvars"
    if [ ! -f "$TFVARS_PATH" ]; then
        echo "Creating dev.tfvars since it does not exist."
        touch "$TFVARS_PATH"
    fi
    
    # Write/overwrite the bucket name in the dev.tfvars file
    echo "state_bucket_name = \"$BUCKET_NAME\"" > "$TFVARS_PATH"
    echo "Bucket name written to dev.tfvars file."
else
    echo "Failed to retrieve or write the bucket name." 1>&2
    exit 1
fi