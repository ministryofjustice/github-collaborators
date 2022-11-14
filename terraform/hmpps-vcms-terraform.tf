module "hmpps-vcms-terraform" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms-terraform"
  collaborators = [
    {
      github_user  = "miriamgo-civica"
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-12"
    },
  ]
}
