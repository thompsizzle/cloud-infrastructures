![version](https://img.shields.io/badge/aws%20provider%20version-4.41.0-blue)

# AWS EC2 Hello World template

## Description

Creates an AWS infrastructure with an EC2 instance, which displays Hello World. Returns the public IP address to the terminal.

## Installation and Usage

### Install AWS CLI

In order to communicate with the AWS API, you will need to install the AWS CLI. Click on the following link for instructions:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

### Configure AWS credentials

Before using this template, you need to configure your AWS credentials.

    aws configure

For more help configuring your AWS credentials: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

### Install Terraform CLI

Please install Terraform on your local machine. Click on the following link for instructions:

https://www.terraform.io/downloads

### Create key for secure connections using SSH

Run the following command to generate SSH key.

    ssh-keygen -t rsa -C "example@gmail.com" -f ./ssh-key-tf

Note: .gitignore has references to this key using the exact name of the key in the command above. Edit the key name, edit the references in .gitignore, under comment '# ssh keys'.

### Available variables

Customize Terraform variables in terraform.tfvars.

AWS region:

    aws_region          = "us-east-1"

VPC CIDR block:

    address_space       = "10.17.0.0/16"

Choose 2 availability zones within region:

    availability_zone_1 = "us-east-1a"
    availability_zone_2 = "us-east-1b"

Define map of amis based on region:

    aws_amis = {
        "us-east-1" = "ami-0cff7528ff583bf9a"
        "us-east-2" = "ami-0ebc8f6f580a04647"
        "us-west-1" = "ami-008b09448b998a562"
        "us-west-2" = "ami-008b09448b998a562"
    }

EC2 instance type:

    ec2_instance_type = "t2.micro"

Be careful when choosing the EC2 instance type. This is what incurs the cost for this infrastructure.

EC2 instance enhanced monitoring:

    ec2_instance_monitoring = false

Enhanced monitoring costs $2.10 per instance, per month.

### Initialize Terraform

Initialize a working directory that contains a Terraform configuration:

    terraform init

### Plan your Terraform

Create an execution plan and preview the changes that Terraform plans to make to your infrastructure:

    terraform plan

### Execute your Terraform

Execute the actions proposed in a Terraform plan:

    terraform apply

### Terraform output

The terminal will output the public IP address of the EC2 instance after execution of `terraform apply`. Copy the IP address and paste into browser to visit EC2 instance over the public internet.

## Least privilege access

Instead of using the credentials of your IAM user with administrator privileges, use an IAM user with much less permission. We should use an IAM user with just enough permission to build the infrastructure we have defined in this template. If you would like to practice the principle of least privilege, follow these steps.

### Create an IAM policy

Create an IAM policy that contains the following:

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "iam:*",
                    "ec2:*"
                ],
                "Resource": "*"
            }
        ]
    }

Here, we are creating a policy that can be attached to a user. This policy only allows for actions with IAM and EC2. Considering the administrator user has permission to all actions for hundreds of AWS services, this is more secure in case the credentials for this user are ever compromised.

### Attach policy to new IAM user

Attach your new policy to a new IAM user. For access type, select access key - Programmatic access. This will provide access keys for the new IAM user to be used when setting up `aws configure`.

### Connect to S3 backend for state storage

Update backend.tf to the following:

    # terraform {
    #     backend "local" {
    #         path = "terraform.tfstate"
    #     }
    # }

    terraform {
      backend "s3" {
        bucket = "tf-state-00000" <-- change to value used for s3 bucket name.
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
    #     bucket = "tf-state-00000"
    #     key    = "ec2-template/terraform.tfstate"
    #     region = "us-east-1"
    #   }
    # }


    terraform init -migrate-state
