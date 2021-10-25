terraform {
  # `backend` blocks do not support variables, so the following are hard-coded here:
  # - S3 bucket name, which is created [here](https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/operations-engineering/resources/s3.tf)
  backend "s3" {
    encrypt = true
    bucket         = "cloud-platform-36623f774b9641d8697d65bdf6b030f5"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "cp-b6970ba60ed66537"
    key     = "github-collaborators/terraform.tfstate"
  }
}
