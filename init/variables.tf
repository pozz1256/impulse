variable "region" {
  default = "us-west-2"
  type = string
}

variable "global_prefix" {
  type    = string
  default = "warp"
}

# for local work
variable "AWS_ACCESS_KEY_ID" {
  type        = string
  default     = "*"
}
variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  default     = "*"
}
