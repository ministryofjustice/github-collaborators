module "cloud-platform-terraform-github-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "cloud-platform-terraform-github-prototype"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "push"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
  ]
}
