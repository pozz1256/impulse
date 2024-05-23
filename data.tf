data "aws_availability_zones" "available" {}

# Get AWS Account ID
data "aws_caller_identity" "current" {}

# Data for check last task definition revision
data "aws_ecs_task_definition" "warp_service" {
  task_definition = aws_ecs_task_definition.main.family
}
data "aws_elb_service_account" "main" {
  region = var.region
}

# Base state file (will need in future)

#data "terraform_remote_state" "base" {
#  backend = "s3"
#
##  config = {
##    bucket  = "warp-terraform-remote-state"
##    key     = "env/base/terraform.tfstate"
##    region  = "us-west-2"
##    acl     = "private"
##    encrypt = true
##  }
#}

#data "aws_iam_policy_document" "inline_policy" {
#  statement {
#    actions   = ["ec2:DescribeAccountAttributes"]
#    resources = ["*"]
#  }
#}