terraform {
  # `backend` blocks do not support variables, so the following are hard-coded here:
  # - S3 bucket name, which is created [here](https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/operations-engineering/resources/s3.tf)
  backend "s3" {
    bucket  = "cloud-platform-36623f774b9641d8697d65bdf6b030f5"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-west-2"
  }
}

provider "github" {
  owner = "ministryofjustice"
  token = var.github_token
}

resource "github_repository_collaborator" "collaborator" {
  repository = "testing-external-collaborators"
  for_each = {
    DangerDawson = "push"
    toonsend     = "triage"
  }
  username   = each.key
  permission = each.value
}
