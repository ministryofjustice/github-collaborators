module "moj-cjse-exiss" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-exiss"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "Ben Pirt"
      email        = "ben@madetech.com"
      org          = "Madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-21"
    },
  ]
}
