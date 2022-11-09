# AWS EC2 Hello World template

## Description

Creates an AWS infrastructure with an EC2 instance, using Terraform. Returns the public IP address to the terminal. Ansible is provided in place of the EC2 instance user data file to configure the EC2 instance operating system and render Hello World.

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

The terminal will output the public IP address of the EC2 instance after execution of `terraform apply`. Copy the IP address and paste into browser to visit EC2 instance over the public internet. The instance will be unreachable, until after we run the Ansible playbook and configure the EC2 instance.
