module "deployment-tools" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-tools"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "maintain"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-01-15"
    },
  ]
}
