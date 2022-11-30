![version](https://img.shields.io/badge/aws%20provider%20version-4.43.0-blue)

# AWS EC2 Hello World with Auto Scaling Group and Load Balancer

## Description

Creates an AWS infrastructure with two EC2 instances, which displays Hello World. These two EC2 instances are managed by an auto scaling group. A load balancer is associated with the auto scaling group to distribute traffic evenly between instances. Returns the DNS name of the load balancer to the terminal.

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

The terminal will output the DNS name of the load balancer after execution of `terraform apply`. Copy the DNS name and paste into browser to visit one of our EC2 instances over the public internet.

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
                    "ec2:*",
                    "s3:*",
                    "elasticloadbalancing:*",
                    "autoscaling:*"
                ],
                "Resource": "*"
            }
        ]
    }

Here, we are creating a policy that can be attached to a user. This policy only allows for actions with IAM, EC2, ELB and ASG. Considering the administrator user has permission to all actions for hundreds of AWS services, this is more secure in case the credentials for this user are ever compromised.

### Attach policy to new IAM user

Attach your new policy to a new IAM user. For access type, select access key - Programmatic access. This will provide access keys for the new IAM user to be used when setting up `aws configure`.
