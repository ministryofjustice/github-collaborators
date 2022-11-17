module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "agilisys-agardner"
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
