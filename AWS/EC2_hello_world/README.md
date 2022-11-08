# EC2 Hello World - AWS template

## Description

Creates an AWS infrastructure with an EC2 instance, which displays Hello World. Returns the public IP address to the console.

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

### Initialize Terraform

Initialize a working directory that contains a Terraform configuration:

    terraform init

### Plan your Terraform

Create an execution plan and preview the changes that Terraform plans to make to your infrastructure:

    terraform plan

### Execute your Terraform

Execute the actions proposed in a Terraform plan:

    terraform apply
