# Overview

To deploy this function code to Lambda, you use a deployment package. This package may either be a .zip file archive or a container image.

For Lambda functions that use the Python runtime, a dependency can be any Python package or module. When you deploy your function using a .zip archive, you can either add these dependencies to your .zip file with your function code or use a Lambda layer.

In this repo, we will skip zip and focus on building container images.

# Container Images

Our goal in this post is to accomplish two things:

0. Create a remote Terraform backend with S3 and DynamoDB
1. Build and push docker images to ECR
2. Deploy the lambda to prod and dev

# 0. Create a remote Terraform backend with S3 and DynamoDB

A backend defines where Terraform stores its state data files.

We need to create the following:

- S3 bucket for the Terraform backend
- DynamoDB table for Terraform state locking and consistency
- IAM role that has permissions to set up the Amazon S3 backend for Terraform

To create these resource for the remote backend, I will create a separate folder called remote_backend outside of the main terraform folder.
