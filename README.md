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

To create these resource for the remote backend, I will create a separate folder called terraform_backend outside of the main terraform folder. I then create a dev and prod folder for each environment, as well as some scripts to bootstrap each environment.

### Bootstrapping

TODO: update bootstrap scripts to populate the .hcl files instead of the .
The bootstrap scripts do two things:

1. provision the s3 and dynamo resources for the backend
2. populates the names of the dynamo and s3 resource into the environment specific .hcl config files.

### IAM for terraform backend

Now that the S3 and DynmoDB resource are created we need to create an IAM role that has permissions to set up the Amazon S3 backend for Terraform.

Step 1: Define the IAM Policy
TODO: do this in the `terraform_backend` folder

You need a policy that includes permissions for S3 bucket operations and DynamoDB table operations as required by Terraform. Here is a JSON representation of such a policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::your-terraform-backend-bucket",
        "arn:aws:s3:::your-terraform-backend-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:region:account-id:table/your-dynamodb-lock-table"
    }
  ]
}
```

Replace your-terraform-backend-bucket with your actual S3 bucket name, region with your AWS region, account-id with your AWS account ID, and your-dynamodb-lock-table with your actual DynamoDB table name.

Step 2: Create the IAM Role
TODO: do this in the `terraform_backend` folder

1. Go to the AWS Management Console.
2. Navigate to IAM -> Roles -> Create role.
3. Choose the trust entity applicable for your scenario (e.g., AWS service, then select the service that will assume this role, such as EC2 if you're running Terraform on an EC2 instance).
4. Attach the policy you created in Step 1.
5. Name your role and create it.

Step 3: Use the Role in GitHub Actions
We want to add the role the `terraform/main.tf` file.

```
terraform {
    backend {
        assume_role {
            role_arn: ""
        }
    }
}
```

To do this dynamically we want to add the role_arn to the `dev_backend.hcl` in the bootstraping step to this:

```
bucket         = "dev-tfstate-bucket-cgx31dmm"
key            = "dev/state/terraform.tfstate"
region         = "us-west-1"
dynamodb_table = "dev-tfstate-locktable"
encrypt        = true
assume_role {
  role_arn = "arn:aws:iam::123456789012:role/TerraformBackendRole"
}
```

Then call `terraform init -backend-config=environments/dev_backend.hcl` in the GHA

### terraform init

NOTE: so this in GHA's: https://github.com/aws-samples/docker-ecr-actions-workflow/blob/main/.github/workflows/workflow.yaml
To init terraform:

- `terraform init -backend-config=environments/dev_backend.hcl`
