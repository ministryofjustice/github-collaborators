module "hmpps-micro-frontend-poc" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-micro-frontend-poc"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "push"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-24"
    },
  ]
}
