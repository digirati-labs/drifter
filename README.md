# Drifter

A tool that can detect and report on configuration drift between the latest repo version of AWS infrastructure Terraform and the deployed result.

This is loosely based upon https://github.com/futurice/terraform-monitor-lambda

## Environment Variables

| Name                    | Description                                                                             | Default |
|-------------------------|-----------------------------------------------------------------------------------------|---------|
| DEBUG                   | Enable debug output                                                                     | False   |
| TERRAFORM_S3_BUCKET     | The S3 bucket that the Terraform is stored in (used to detect Terraform version in use) |         |
| TERRAFORM_S3_KEY        | The key of the Terraform remote state in S3 (see `TERRAFORM_S3_BUCKET`, above)          |         |
| TERRAFORM_GITHUB_REPO   | GitHub repository in format `user/repo`                                                 |         |
| TERRAFORM_GITHUB_BRANCH | GitHub repository branch to use                                                         | master  |
| TERRAFORM_GITHUB_FOLDER | Subfolder within GitHub repository for Terraform                                        |         |
| TERRAFORM_GITHUB_TOKEN  | GitHub access token for the repo defined in `TERRAFORM_GITHUB_REPO`                     |         |
| CLOUDWATCH_NAMESPACE    | AWS CloudWatch metric namespace where metrics should be shipped                         |         |
| AWS_REGION              | AWS Region name                                                                         |         |
| SLACK_WEBHOOK_URL       | Slack Webhook URL to emit messages to                                                   |         |
| TMP_FOLDER              | Temporary folder to use                                                                 | /tmp    |


## Permissions - AWS

From an AWS point of view these are handled by the Terraform. We don't know the scope of the Terraform that we will be asked to check, but we do know that we don't want to be able to change anything, so in the Terraform packaged with this module the Drifter task is given `arn:aws:iam::aws:policy/ReadOnlyAccess` which is a pre-rolled AWS policy that gives read-only access to all resource types.

## Permissions - GitHub

For GitHub, the access token given to Drifter must have READ access to the Terraform source repository. In Digirati's case, we'd simply add the `CI` team with READ access to the repository Teams list.

## Terraform

Terraform module for scheduled checking using Drifter, with notifications sent to a Slack webhook and metrics emitted to Cloudwatch.

| Variable                | Description                                                         | Default           |
|-------------------------|---------------------------------------------------------------------|-------------------|
| prefix                  | Prefix to give to AWS resources                                     |                   |
| slack_webhook_url       | Slack Webhook URL for notifications                                 |                   |
| terraform_identifier    | Identifier for the Drifter task (e.g. `my-tf-repo-master`)          |                   |
| terraform_s3_bucket     | Name of S3 bucket that the Terraform resides in                     |                   |
| terraform_s3_key        | S3 Key of the Terraform remote state file                           | terraform.tfstate |
| terraform_github_repo   | GitHub repository in format `user/repo`                             |                   |
| terraform_github_branch | GitHub repository branch to use                                     | master            |
| terraform_github_folder | Subfolder within GitHub repository for Terraform                    |                   |
| terraform_github_token  | GitHub access token for the repo defined in `terraform_github_repo` |                   |
| cloudwatch_namespace    | AWS CloudWatch metric namespace where metrics should be shipped     |                   |
| tmp_folder              | Temporary folder to use                                             | /tmp              |
| log_group_name          | CloudWatch log group name that the container will emit logs to      |                   |
| region                  | AWS Region for resources                                            |                   |
| account_id              | AWS account ID                                                      |                   |
| cluster_id              | The cluster on which to run the scheduled ECS task                  |                   |
| cron_expression         | Cron scheduling expression in form `cron(x x x x x x)`              |                   |

### Example

```
module "drifter_estate" {
  source                 = "git::https://github.com/digirati-labs/terraform-drifter.git//"
  slack_webhook_url      = "${var.slack_webhook_status}"
  terraform_identifier   = "my-terraform-repo-master"
  terraform_s3_bucket    = "my-state-bucket"
  terraform_github_repo  = "my-github-user/my-terraform-repo"
  terraform_github_token = "${data.aws_ssm_parameter.terraform_github_token.value}"
  cloudwatch_namespace   = "terraform-drift"
  log_group_name         = "${var.log_group_name}"
  prefix                 = "${var.prefix}"
  region                 = "${var.region}"
  account_id             = "${var.account_id}"
  cluster_id             = "${module.metropolis_cluster.cluster_id}"
  cron_expression        = "cron(0 0 * * ? *)"
}

```
