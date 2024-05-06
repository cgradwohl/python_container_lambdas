#!/bin/bash

# Set the directory where your Terraform configuration files are located
TERRAFORM_DIR="terraform_backend/prod"

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
echo "Applying Terraform configuration for the production environment..."
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
    
    # Check if prod.tfvars exists, create if it does not
    TFVARS_PATH="../../terraform/environments/prod.tfvars"
    if [ ! -f "$TFVARS_PATH" ]; then
        echo "Creating dev.tfvars since it does not exist."
        touch "$TFVARS_PATH"
    fi
    
    # Append the bucket name to the dev.tfvars file
    echo "state_bucket_name = \"$BUCKET_NAME\"" >> "$TFVARS_PATH"
    echo "Bucket name appended to prod.tfvars file."
else
    echo "Failed to retrieve or append the bucket name." 1>&2
    exit 1
fi