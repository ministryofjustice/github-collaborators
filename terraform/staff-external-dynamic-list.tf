module "staff-external-dynamic-list" {
  source     = "./modules/repository-collaborators"
  repository = "staff-external-dynamic-list"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-19"
    },
  ]
}
