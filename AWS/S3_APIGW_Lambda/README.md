![version](https://img.shields.io/badge/aws%20provider%20version-4.39.0-blue)

# AWS S3 Hello World static website with API Gateway and Lambda

## Description

Creates a S3 bucket configured to host a static website. The site communicates asynchronously with API Gateway, which triggers a Lambda function. The Lambda function returns a 'hello world' string back through API Gateway and then through to the S3 static website to display for users.

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

Coming soon.

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

The terminal will output the endpoint of the S3 static website and distribution domain name after execution of `terraform apply`. Copy the either endpoint address and paste into browser to visit your static website hosted by S3 and website served by CloudFront.

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
                    "s3:*",
                    "ec2:*",
                    "iam:*",
                    "lambda:*",
                    "apigateway:*"
                ],
                "Resource": "*"
            }
        ]
    }

Here, we are creating a policy that can be attached to a user. This policy only allows for actions with S3 and CloudFront. Considering the administrator user has permission to all actions for hundreds of AWS services, this is more secure in case the credentials for this user are ever compromised.

### Attach policy to new IAM user

Attach your new policy to a new IAM user. For access type, select access key - Programmatic access. This will provide access keys for the new IAM user to be used when setting up `aws configure`.
