![version](https://img.shields.io/badge/aws%20provider%20version-4.48.0-blue)

# AWS EC2 Hello World with Auto Scaling Group and Load Balancer

Creates an AWS infrastructure with two EC2 Instances behind an Auto Scaling Group displaying 'Hello World'.

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
                    "dynamodb:*",
                    "elasticloadbalancing:*",
                    "autoscaling:*"
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
| aws | >= 4.43.0 |

### Create key for secure connections using SSH

Run the following command to generate SSH key.

    ssh-keygen -t rsa -C "example@gmail.com" -f ./ssh-key-tf

Note: .gitignore has references to this key using the exact name of the key in the command above. Edit the key name, edit the references in .gitignore.

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.43.0 |

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
| [aws_route_table.rt_web_igw_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rt_associate_web_a_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_associate_web_b_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.ec2_public_access_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_launch_template.lt_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb_target_group.lb_tg_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.lb_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.lb_listener_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_autoscaling_group.asg_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_s3_bucket.bucket_logs_tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.allow_access_from_only_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to launch infrastructure. | `string` | `"us-east-1"` | no |
| address_space | CIDR for VPC. | `string` | `"us-east-1"` | no |
| availability_zone_1 | Availability Zone within region. | `string` | `"us-east-1a"` | no |
| availability_zone_2 | Availability Zone within region. | `string` | `"us-east-1b"` | no |
| aws_amis | A map of region-specific AMI IDs. | `list(map(any))` | <pre>[<br>   {<br>       "us-east-1" = "ami-0cff7528ff583bf9a"<br>       "us-east-2" = "ami-0ebc8f6f580a04647"<br>       "us-west-1" = "ami-008b09448b998a562"<br>       "us-west-2" = "ami-008b09448b998a562"<br>   }<br>]</pre> | no |
| ec2_instance_type | EC2 instance type. | `string` | `"t3.micro"` | no |
| ec2_instance_monitoring | Enable enhanced monitoring ($2.10/instance/month). | `bool` | `false` | no |
| aws_elb_account_id | Map of AWS accounts for Elastic Load Balancing for regions in U.S. | `list(map(any))` | <pre>[<br>   {<br>       "us-east-1" = "127311923021"<br>       "us-east-2" = "033677994240"<br>       "us-west-1" = "027434742980"<br>       "us-west-2" = "797873946194"<br>   }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|------|
| load_balancer_dns | Public IP of Auto Scaling Group. |
