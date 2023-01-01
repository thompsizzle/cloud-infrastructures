![version](https://img.shields.io/badge/hashicorp/aws-v4.48.0-blue)
![version](https://img.shields.io/badge/hashicorp/random-v3.4.3-blue)

# AWS EC2 Instance template

Creates an AWS infrastructure with an EC2 instance displaying 'Hello World'.

## Usage

terraform.tfvars

    aws_region          = "us-west-1"
    address_space       = "10.10.0.0/16"
    availability_zone_1 = "us-west-1a"
    availability_zone_2 = "us-west-1b"
    aws_amis = {
        "us-east-1" = "ami-0cff7528ff583bf9a"
        "us-east-2" = "ami-0ebc8f6f580a04647"
        "us-west-1" = "ami-008b09448b998a562"
        "us-west-2" = "ami-008b09448b998a562"
    }
    ec2_instance_type       = "t3.micro"
    ec2_instance_monitoring = true

## IAM policy least privilege access

Instead of using the credentials of an IAM user with administrator privileges, use an IAM user with the minimal permissions needed to complete the tasks. We should use an IAM user with just enough permission to build the infrastructure we have defined in this template.

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "EC2InstanceTemplateAccess",
                "Effect": "Allow",
                "Action": [
                    "iam:*",
                    "ec2:*",
                    "s3:*",
                    "dynamodb:*"
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

### Create key for secure connections using SSH

Run the following command to generate SSH key.

    ssh-keygen -t rsa -C "example@gmail.com" -f ./ssh-key-tf

Note: .gitignore has references to this key using the exact name of the key in the command above. Edit the key name, edit the references in .gitignore.

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
| [aws_vpc.vpc_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.sn_web_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_app_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_db_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_reserved_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_web_b_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_app_b_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_db_b_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.sn_reserved_b_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_internet_gateway.vpc_igw_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_security_group.ec2_public_access_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_key_pair.ec2_ssh_key_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route_table.rt_web_igw_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rt_associate_web_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_associate_web_b_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_network_interface.eni_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_instance.ec2_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_s3_bucket.bucket_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.versioning_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_public_access_block.private_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [random_integer.bucket](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to launch infrastructure. | `string` | `"us-east-1"` | no |
| address_space | CIDR for VPC. | `string` | `"us-east-1"` | no |
| availability_zone_1 | Availability Zone within region. | `string` | `"us-east-1a"` | no |
| availability_zone_2 | Availability Zone within region. | `string` | `"us-east-1b"` | no |
| aws_amis | A map of region-specific AMI IDs. | `list(map(string))` | <pre>[<br>  {<br>    "us-east-1" = "ami-0cff7528ff583bf9a"<br>    "us-east-2" = "ami-0ebc8f6f580a04647"<br>    "us-west-1" = "ami-008b09448b998a562"<br>    "us-west-2" = "ami-008b09448b998a562"<br>  }<br>]</pre> | no |
| ec2_instance_type | EC2 instance type. | `string` | `"t3.micro"` | no |
| ec2_instance_monitoring | Enable enhanced monitoring ($2.10/instance/month). | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|------|
| public_ip | Public IP of EC2 instance. |
| state_bucket_id | ID of S3 bucket created in case user wants to store state in S3 bucket. |

## Compatible regions

| Region |
|------|
| us-east-1 |
| us-east-2 |
| us-west-1 |
| us-west-2 |

## Use S3 backend for state storage and DynamoDB lock scenerio

Update backend.tf to the following:

    # terraform {
    #     backend "local" {
    #         path = "terraform.tfstate"
    #     }
    # }

    terraform {
      backend "s3" {
        bucket = "tf-state-12345" <-- change to state_bucket_id output value.
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
