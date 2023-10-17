module "hmpps-micro-frontend-components" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-micro-frontend-components"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-01-15"
    },
  ]
}
