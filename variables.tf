variable "db_username" {
  description = "The username for the RDS database"
  type        = string
  default = "warp_user"
}
variable "region" {
  default = "us-west-2"
  type = string
}
variable "global_prefix" {
  default = "warp"
  type = string
}
variable "engine_version" {
  default = "8.0"
}
variable "major_engine_version" {
  default = "8.0"
}
variable "db_family" {
  default = "mysql8.0"
}