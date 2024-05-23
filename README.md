# Terraform AWS Infrastructure for Deploying Warp Application

This repository contains Terraform code for deploying the [Warp application](https://github.com/sebo-b/warp) on AWS. The infrastructure includes ECS, ALB, RDS, and VPC, and is automated using a Makefile.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS CLI configured with appropriate permissions
- [Docker](https://www.docker.com/get-started) installed

## Infrastructure Components

- **VPC**: A Virtual Private Cloud to host our resources.
- **Subnets**: Two public subnets within the VPC.
- **RDS**: A MySQL database instance.
- **ECS**: A cluster to run the application.
- **ALB**: An Application Load Balancer to distribute traffic to the ECS tasks.
- **IAM**: Roles and policies for ECS tasks.

## Setup Instructions

### For work with this IAAC you should Clone the Repository

```sh
git clone https://github.com/pozz1256/task.git

### For work with warp app, you should clone inside task repository warp repository (git clone https://github.com/sebo-b/warp.git) and copy files from root to warp repository.


###For work with warp app you need go to /warp folder.

## Software Requirements

Terraform >= v1.1.3

AWS CLI

## AWS Profile

Create an AWS account and get aws_access_key_id and aws_secret_access_key.
Follow [this instruction](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) from AWS to configure your AWS profile.

## Apply Infrastructure

You shouldn't run this step if you are not sure. There is a **$ROOT/task/init/terraform.tfstate** file in the source control, you can delete it if you want to start from the scratch.

```terraform init```

```terraform plan```

```terraform apply``` 

This will create the lock table in the S3 bucket for storing the current Terraform state for all other modules. In all other directories listed below, you will need to do, at a minimum **terraform init** to get your working directory synced with the live state.

### Terraform

There are init folder, its created for future, as I dont have aws account and cant create s3 bucket for store inside terraform state folder.

To get started, first initialize your local terraform state information:

```terraform init```