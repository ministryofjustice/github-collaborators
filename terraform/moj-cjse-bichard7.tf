module "moj-cjse-bichard7" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-bichard7"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-09-19"
    },
  ]
}
