module "hmpps-vcms-terraform" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms-terraform"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "pull"
      name         = "Simon Creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "civica"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
  ]
}
