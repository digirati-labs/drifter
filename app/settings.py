import os
import database
import re
import distutils.util
from database.sqlite_database import SqliteDatabase
from database.postgresql_database import PostgreSqlDatabase

DEBUG = bool(distutils.util.strtobool(os.getenv("DEBUG", "False")))
DB_TYPE = os.getenv("DB_TYPE")
TERRAFORM_S3_BUCKET = os.getenv("TERRAFORM_S3_BUCKET")
TERRAFORM_S3_KEY = os.getenv("TERRAFORM_S3_KEY")
TERRAFORM_GITHUB_REPO = os.getenv("TERRAFORM_GITHUB_REPO")
TERRAFORM_GITHUB_BRANCH = os.getenv("TERRAFORM_GITHUB_BRANCH", default="master")
TERRAFORM_GITHUB_TOKEN = os.getenv("TERRAFORM_GITHUB_TOKEN")
TERRAFORM_GITHUB_FOLDER = os.getenv("TERRAFORM_GITHUB_FOLDER")
CLOUDWATCH_NAMESPACE = os.getenv("CLOUDWATCH_NAMESPACE")
AWS_REGION = os.getenv("AWS_REGION")
SLACK_WEBHOOK_URL = os.getenv("SLACK_WEBHOOK_URL")
TMP_FOLDER = os.getenv("TMP_FOLDER", default="/tmp")


def get_database():
  if DB_TYPE == "postgresql":
    return get_database_postgresql()
  else:
    return get_database_sqlite()


def get_database_postgresql():
  db = PostgreSqlDatabase()
  db.initialise({
    "dbname": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "host": os.getenv("DB_HOST"),
    "password": os.getenv("DB_PASSWORD")
  })

  return db


def get_database_sqlite():
  db = SqliteDatabase()
  db.initialise({
    "db_name": os.getenv("DB_NAME")
  })

  return db