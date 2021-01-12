terraform {
  # `backend` blocks do not support variables, so the following are hard-coded here:
  # - S3 bucket name, which is created [here](https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/operations-engineering/resources/s3.tf)
  backend "s3" {
    encrypt = true
    key     = "terraform.tfstate"
  }
}

provider "github" {
  owner = "ministryofjustice"
  token = var.github_token
}
