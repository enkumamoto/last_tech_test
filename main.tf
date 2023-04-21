terraform { # The terraform block was missed and included
  required_version = ">=1.4.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.3"
    }
  }
}

provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["248772781588"]

  default_tags {
    tags = {
      purpose = "tf-hiring-test"
      owner = "${var.CandidateName}"
    }
  }
}

