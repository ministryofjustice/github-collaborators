module "hmpps-engineering-accelerator-team" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-accelerator-team"
  collaborators = [
    {
      github_user  = "mcoffey-mt"
      permission   = "pull"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
  ]
}
