# Drifter

A tool that can detect and report on configuration drift between the latest repo version of infrastructure Terraform and the deployed result.

This is loosely based upon https://github.com/futurice/terraform-monitor-lambda

## Environment Variables

| Name                    | Description                                                                             | Default |
|-------------------------|-----------------------------------------------------------------------------------------|---------|
| DEBUG                   | Enable debug output                                                                     | False   |
| TERRAFORM_S3_BUCKET     | The S3 bucket that the Terraform is stored in (used to detect Terraform version in use) |         |
| TERRAFORM_S3_KEY        | The key of the Terraform remote state in S3 (see `TERRAFORM_S3_BUCKET`, above)          |         |
| TERRAFORM_GITHUB_REPO   | GitHub repository in format `user/repo`                                                 |         |
| TERRAFORM_GITHUB_BRANCH | GitHub repository branch to use                                                         | master  |
| TERRAFORM_GITHUB_TOKEN  | GitHub access token for the repo defined in `TERRAFORM_GITHUB_REPO`                     |         |
| TERRAFORM_GITHUB_FOLDER | Subfolder within GitHub repository for Terraform                                        |         |
| CLOUDWATCH_NAMESPACE    | AWS CloudWatch metric namespace where metrics should be shipped                         |         |
| SLACK_WEBHOOK_URL       | Slack Webhook URL to emit messages to                                                   |         |
| TMP_FOLDER              | Temporary folder to use                                                                 | /tmp    |

## sqlite

To use sqlite as the backing database, set the following:
```
DB_TYPE='sqlite'
```

| Name    | Description                                   | Default    |
|---------|-----------------------------------------------|------------|
| DB_NAME | This is the full path of the .db file to use. | cupcake.db |

## PostgreSQL

To use PostgreSQL as the backing database, set the following:
```
DB_TYPE='postgresql'
```

| Name        | Description                                              | Default |
|-------------|----------------------------------------------------------|---------|
| DB_NAME     | This is the database name                                |         |
| DB_HOST     | This is the database host and port in `host:port` format |         |
| DB_USER     | This is the username to connect to database with         |         |
| DB_PASSWORD | This is the password to connect to database with         |         |
