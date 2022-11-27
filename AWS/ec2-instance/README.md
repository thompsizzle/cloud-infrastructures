![version](https://img.shields.io/badge/aws%20provider%20version-4.41.0-blue)

# AWS EC2 Instance template

Creates an AWS infrastructure with an EC2 instance displaying 'Hello World'. Outputs public IP address.

## Minimal usage

terraform.tfvars

    s3_state_bucket = "tf-state-12345"

## Advanced usage

terraform.tfvars

    s3_state_bucket     = "tf-state-12345"
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

## Use S3 backend for state storage scenerio

Update backend.tf to the following:

    # terraform {
    #     backend "local" {
    #         path = "terraform.tfstate"
    #     }
    # }

    terraform {
      backend "s3" {
        bucket = "tf-state-12345" <-- change to value used for s3 bucket name.
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

You now have your terraform state file being stored in S3. The reason I recommend using the -recofigure flag is to empty the local terraform.tfstate file to avoid confusion. The original terraform state, before the migration to S3 is still saved in terraform.tfstate.backup.

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
                    "s3:*"
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
| aws | >= 4.41.0 |

### Create key for secure connections using SSH

Run the following command to generate SSH key.

    ssh-keygen -t rsa -C "example@gmail.com" -f ./ssh-key-tf

Note: .gitignore has references to this key using the exact name of the key in the command above. Edit the key name, edit the references in .gitignore.

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.41.0 |

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to launch infrastructure. | `string` | `"us-east-1"` | no |
| address_space | CIDR for VPC. | `string` | `"us-east-1"` | no |
| availability_zone_1 | Availability Zone within region. | `string` | `"us-east-1a"` | no |
| availability_zone_2 | Availability Zone within region. | `string` | `"us-east-1b"` | no |
| aws_amis | A map of region-specific AMI IDs. | `list(map(string))` | <pre>[<br>   {<br>       "us-east-1" = "ami-0cff7528ff583bf9a"<br>       "us-east-2" = "ami-0ebc8f6f580a04647"<br>       "us-west-1" = "ami-008b09448b998a562"<br>       "us-west-2" = "ami-008b09448b998a562"<br>   }<br>]</pre> | no |
| ec2_instance_type | EC2 instance type. | `string` | `"t3.micro"` | no |
| ec2_instance_monitoring | Enable enhanced monitoring ($2.10/instance/month). | `bool` | `false` | no |
| s3_state_bucket | Name of S3 bucket to store Terraform state file. | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|------|
| public_ip | Public IP of EC2 instance |
