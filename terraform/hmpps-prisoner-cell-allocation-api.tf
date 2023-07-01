module "hmpps-prisoner-cell-allocation-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-prisoner-cell-allocation-api"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "push"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-09-29"
    },
  ]
}
