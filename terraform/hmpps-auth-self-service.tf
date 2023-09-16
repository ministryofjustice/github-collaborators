module "hmpps-auth-self-service" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-auth-self-service"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-15"
    },
  ]
}
