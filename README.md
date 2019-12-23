# Onica AWS Code Exercise

This is a DevOps AWS Code Exercise for Onica

  * [Overview](#overview)
  * [Requirements](#requirements)
  * [Dependencies](#dependencies)
  * [Instructions](#instructions)
    * [Setup AWS Infrastructure](#setup-aws-infrastructure)
  * [Display Autoscaling](#display-autoscaling)


## Overview

**This project is not 100% working**

A simple Flask web application which is containerized with nginx through docker-compose.
Most actions are handled by `make` all the way to the deployment of the application
in AWS.

1. Clone the project

```bash
git clone git@github.com:byronmansfield/onica.git
```

2. Initialize Infrastruction

This will setup all of the Infrastructure as code. (Still needs to be completed)

```bash
make init
```

3. Build the project

Since this is a simple project, it does nothing more than a `docker build`

```bash
make build
```

4. Publish the built image

```bash
make publish
```

5. Deploy

Stand up the AWS infrastructure

```bash
make plan
make deploy
```

6. Autoscale

In order to display the Autoscaling functionality this will simulate user traffic

```bash
make autoscale
```


## Requirements

The requirements for this project are as follows:

- [ ] VPC with private/public subnets and all required dependent infrastructure as
			long as you do not use the default VPC.
- [ ] ELB to be used to register web server instances.
  - [ ] Include a simple health check to make sure the web servers are responding.
  - [ ] The health check should automatically replace instances if they are unhealthy,
    		and the instances should come back into service on their own.
- [ ] Auto Scaling Group and Launch Configuration that launches EC2 instances and
  		registers them to the ELB.
  - [ ] Establish a min, max, and desired server count that scales up/down based on
    		a metric of choice (and be able to demonstrate a scaling event).
- [ ] Security Group allowing HTTP traffic to the load balancer from anywhere (not
  		directly to the instance(s)).
- [ ] Remote management ports such as SSH and RDP must not be open to the world.
- [ ] Some kind of automation or scripting that achieves the following:
  - [ ] Install a web server (Apache or Nginx).
  - [ ] Deploys a simple "hello world" page for the web serve.
  - [ ] Can be written in any language.
  - [ ] Can be sourced from the location of choice (S3, cookbook file/ template, etc).
  - [ ] Must include the server's hostname in the "hello world" presented to the user.
- [ ] All AWS resources must be created using Terraform or CloudFormation.
- [ ] No resources may be created or managed by hand other than EC2 SSH keys.


## Dependencies

* AWS account
* AWS CLI v2
* make
* Terraform v12


## Instructions


### Setup AWS Infrastructure

Once you have pulled the repo locally and installed `terraform`. You will also
need to make sure that you have your AWS credentials as environment variables
like so:

```bash
export AWS_ACCT_ID=XXxXXxxXXxXX
export AWS_ACCESS_KEY_ID=XxXxxXXxxxXXXXXxXXXX
export AWS_SECRET_ACCESS_KEY=XXxXxXXXxxxXxXxxxxxxxxXxxXXXxXxXXXxXX
```

Create the terraform state bucket and set versioning on it

```bash
aws s3api create-bucket --bucket terraform-onica --region us-east-1
aws s3api put-bucket-versioning --bucket terraform-onica --versioning-configuration Status=Enabled
```

NOTE: You could technically put the s3 terraform bucket setup in terraform, but
it is probably best to put it in a separate terraform sub-directory, and you should
only need to run it once. So since it's not exactly "project specific" I chose to
keep it simple and display a native way of doing so. Another way would be some
setup script such as `make init` or `./setup.sh` but it's only two lines of code.


Initialize `terraform`

```bash
terraform init -upgrade=true -var-file=onica.tfvars
```

Setup terraform workspace

```bash
terraform workspace new onica
terraform workspace select onica
```

Check the plan and stand up the infrastructure

```bash
terraform plan -var-file=onica.tfvars -out plan.out
terraform apply plan.out
```
