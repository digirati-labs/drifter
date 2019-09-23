locals {
  identifier = "drifter-${var.terraform_identifier}"
}

module "drifter_task" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/base/"

  environment_variables = {
    "DEBUG"                   = "True"
    "SLACK_WEBHOOK_URL"       = "${var.slack_webhook_url}"
    "TERRAFORM_S3_BUCKET"     = "${var.terraform_s3_bucket}"
    "TERRAFORM_S3_KEY"        = "${var.terraform_s3_key}"
    "TERRAFORM_GITHUB_REPO"   = "${var.terraform_github_repo}"
    "TERRAFORM_GITHUB_BRANCH" = "${var.terraform_github_branch}"
    "TERRAFORM_GITHUB_FOLDER" = "${var.terraform_github_folder}"
    "TERRAFORM_GITHUB_TOKEN"  = "${var.terraform_github_token}"
    "CLOUDWATCH_NAMESPACE"    = "${var.cloudwatch_namespace}"
    "AWS_REGION"              = "${var.region}"
    "TMP_FOLDER"              = "${var.tmp_folder}"
  }

  environment_variables_length = 11

  prefix           = "${var.prefix}"
  log_group_name   = "${var.log_group_name}"
  log_group_region = "${var.region}"
  log_prefix       = "${var.prefix}-${local.identifier}"

  family = "${var.prefix}-${local.identifier}"

  container_name = "${var.prefix}-${local.identifier}"

  cpu_reservation    = 0
  memory_reservation = 128

  docker_image = "${var.drifter_docker_image}"
}

module "drifter" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/scheduled/"

  family              = "${var.prefix}-${local.identifier}"
  task_role_name      = "${module.drifter_task.role_name}"
  region              = "${var.region}"
  account_id          = "${var.account_id}"
  cluster_arn         = "${var.cluster_id}"
  schedule_expression = "${var.cron_expression}"
  desired_count       = 1
  task_definition_arn = "${module.drifter_task.task_definition_arn}"
}

data "aws_s3_bucket" "terraform_s3_bucket" {
  bucket = "${var.terraform_s3_bucket}"
}

data "aws_iam_policy_document" "drifter_abilities" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${data.aws_s3_bucket.terraform_s3_bucket.arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${data.aws_s3_bucket.terraform_s3_bucket.arn}/*",
    ]
  }

  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "drifter_abilities" {
  name   = "${var.prefix}-drifter-${local.identifier}-abilities"
  role   = "${module.drifter_task.role_name}"
  policy = "${data.aws_iam_policy_document.drifter_abilities.json}"
}

data "aws_iam_policy" "readonly" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "drifter_readonly" {
  role       = "${module.drifter_task.role_name}"
  policy_arn = "${data.aws_iam_policy.readonly.arn}"
}
