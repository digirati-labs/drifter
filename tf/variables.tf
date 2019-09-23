variable "slack_webhook_url" {}
variable "terraform_identifier" {}
variable "terraform_s3_bucket" {}

variable "terraform_s3_key" {
  default = "terraform.tfstate"
}

variable "terraform_github_repo" {}

variable "terraform_github_branch" {
  default = "master"
}

variable "terraform_github_folder" {
  default = ""
}

variable "terraform_github_token" {}
variable "cloudwatch_namespace" {}

variable "tmp_folder" {
  default = "/tmp"
}

variable "log_group_name" {}
variable "prefix" {}
variable "region" {}

variable "drifter_docker_image" {
  default = "digirati/drifter:latest"
}

variable "account_id" {}
variable "cluster_id" {}
variable "cron_expression" {}
