provider "aws" {
  region                   = "us-east-1"
  shared_credentials_file = "~/.aws/credentials" #default on linux
  # %USERPROFILE%\.aws\credentials default on Windows
  profile = "default" # this parameter is used when we specify the name in the shared credentials files
}


terraform {
  backend "s3" {
    bucket = "wordpressappdeploy"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
