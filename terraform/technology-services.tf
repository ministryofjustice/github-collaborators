module "technology-services" {
  source     = "./modules/repository-collaborators"
  repository = "technology-services"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-15"
    },
  ]
}
