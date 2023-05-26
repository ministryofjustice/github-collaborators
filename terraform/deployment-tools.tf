module "deployment-tools" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-tools"
  collaborators = [
    {
      github_user  = "mcoffey-mt"
      permission   = "maintain"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-24"
    },
  ]
}
