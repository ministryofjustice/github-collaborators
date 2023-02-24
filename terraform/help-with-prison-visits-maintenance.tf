module "help-with-prison-visits-maintenance" {
  source     = "./modules/repository-collaborators"
  repository = "help-with-prison-visits-maintenance"
  collaborators = [
    {
      github_user  = "mcoffey-mt"
      permission   = "push"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-25"
    },
  ]
}
