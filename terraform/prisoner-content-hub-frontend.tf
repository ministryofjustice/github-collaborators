module "prisoner-content-hub-frontend" {
  source     = "./modules/repository-collaborators"
  repository = "prisoner-content-hub-frontend"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-01-23"
    },
  ]
}
