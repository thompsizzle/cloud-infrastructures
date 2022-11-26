# Collection of cloud infrastructure templates for AWS

This repository hosts a collection of templates that can be used to create various cloud infrastructures in AWS.

## Included content

Click on the name of a template to view that content's documentation:

### AWS templates
Name | Description | Cost
--- | --- | ---
[EC2 Hello World](https://github.com/thompsizzle/cloud-infrastructures/tree/main/AWS/EC2_hello_world)|Creates an AWS infrastructure with an EC2 instance, which displays Hello World. Returns the public IP address to the terminal.|$8.39/month
[EC2 Hello World with Ansible](https://github.com/thompsizzle/cloud-infrastructures/tree/main/AWS/EC2_hello_world_Ansible)|Creates an AWS infrastructure with an EC2 instance, using Terraform. Returns the public IP address to the terminal. Ansible is provided in place of the EC2 instance user data file to configure the EC2 instance operating system and render Hello World.|$9.27/month
[EC2 Hello World with ASG](https://github.com/thompsizzle/cloud-infrastructures/tree/main/AWS/EC2_hello_world_ASG)|Creates an AWS infrastructure with two EC2 instances, which displays Hello World. These two EC2 instances are managed by an auto scaling group. A load balancer is associated with the auto scaling group to distribute traffic evenly between instances. Returns the DNS name of the load balancer to the terminal.|$33.36/month
[S3 Hello World](https://github.com/thompsizzle/cloud-infrastructures/tree/main/AWS/EC2_hello_world_ASG)|Creates a S3 bucket configured to host a static website. A bucket policy is added which is required for the static website to be accessible to the public. An index.html file is uploaded to the bucket as an object to act as the home page of the static website.|$0.00/month<br><a href="https://aws.amazon.com/s3/pricing/" target="_blank">See costs</a>
[S3 Hello World with CDN](https://github.com/thompsizzle/cloud-infrastructures/tree/main/AWS/S3_hello_world_CDN)|Creates a S3 bucket configured to host a static website and served by CloudFront. The CloudFront distribution is configured with an access control policy. The S3 bucket is not accessible to the public, only to the CloudFront distribution. An index.html file is uploaded to the bucket as an object to act as the home page of the static website.|$0.00/month<br><a href="https://aws.amazon.com/s3/pricing/" target="_blank">See costs</a>

## Monthly cost tool

We use <a href="https://www.infracost.io/" target="_blank">Infracost</a> here to determine the monthly cost of resources. Check out this awesome tool!
