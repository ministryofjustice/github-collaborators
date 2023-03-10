module "deployment-tools" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-tools"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "maintain"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
  ]
}
