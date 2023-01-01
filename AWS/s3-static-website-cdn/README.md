![version](https://img.shields.io/badge/hashicorp/aws-v4.48.0-blue)
![version](https://img.shields.io/badge/hashicorp/random-v3.4.3-blue)

# AWS S3 Static Website

Creates a S3 bucket configured to host a static website and served by CloudFront. The CloudFront distribution is configured with an access control policy. The S3 bucket is not accessible to the public, only to the CloudFront distribution. An index.html file is uploaded to the bucket as an object to act as the home page of the static website.

## Usage

terraform.tfvars

    s3_bucket = "REPLACE_ME"

## IAM policy least privilege access

Instead of using the credentials of an IAM user with administrator privileges, use an IAM user with the minimal permissions needed to complete the tasks. We should use an IAM user with just enough permission to build the infrastructure we have defined in this template.

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "S3StaticWebsiteCDNTemplateAccess",
                "Effect": "Allow",
                "Action": [
                    "s3:*",
                    "dynamodb:*",
                    "cloudfront:*"
                ],
                "Resource": "*"
            }
        ]
    }

Considering the administrator user has permission to all actions for hundreds of AWS services, this is more secure in case the credentials for this user are ever compromised.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.4 |
| aws | >= 4.48.0 |
| random | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.48.0 |
| random | >= 3.4.3 |

## Backends available

| Name | Type |
|------|------|
| [Local](https://developer.hashicorp.com/terraform/language/settings/backends/local) | backend |
| [S3](https://developer.hashicorp.com/terraform/language/settings/backends/s3) | backend |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.bucket_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_website_configuration.bucket_config_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucketaws_s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_policy.bucket_policy_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_versioning.versioning_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.object_index](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.object_error](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_s3_bucket.state_bucket_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.state_versioning_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_public_access_block.private_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_dynamodb_table.terraform_state_lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [random_integer.bucket](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to launch infrastructure. | `string` | `"us-east-1"` | no |
| s3_bucket | Name of S3 bucket to host static website. | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|------|
| s3_static_website_endpoint | Public address of static website. |
| distribution_domain_name | Public address of Cloudfront Distribution. |
| state_bucket_id | ID of S3 bucket created in case user wants to store state in S3 bucket. |

## Compatible regions

| Region |
|------|
| global |

## Use S3 backend for state storage and DynamoDB lock scenerio

Update backend.tf to the following:

    # terraform {
    #     backend "local" {
    #         path = "terraform.tfstate"
    #     }
    # }

    terraform {
      backend "s3" {
        bucket = "REPLACE_ME" <-- change to state_bucket_id output value.
        key    = "state_tf"
        region = "us-east-1"
      }
    }

Replace the value for `bucket` with variable used for s3_state_bucket.

Run the following command to reconfigure Terraform:

    terraform init -reconfigure

When prompted:

    Do you want to copy existing state to the new backend?
    Enter a value: yes

You now have your terraform state file being stored in S3. The lock file will be stored in DynamoDB. The reason I recommend using the -recofigure flag is to empty the local terraform.tfstate file to avoid confusion.

Important! Now that we are storing the state file in S3, we will need to migrate the state locally before running a `terraform destroy`.

Before running `terraform destroy`, copy the current state back to our local terraform.tfstate file.

    terraform state pull > terraform.tfstate

Your terraform state is now being stored locally again.

Comment out the code within backend.tf and reconfigure Terraform to use our local as its backend.

    terraform {
        backend "local" {
            path = "terraform.tfstate"
        }
    }

    # terraform {
    #   backend "s3" {
    #     bucket = "tf-state-12345"
    #     key    = "ec2-template/terraform.tfstate"
    #     region = "us-east-1"
    #   }
    # }

Run the following to stop using S3 as backend and use local.

    terraform init -migrate-state

