module "hmpps-engineering-accelerator-team" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-accelerator-team"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "pull"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-01-23"
    },
  ]
}
