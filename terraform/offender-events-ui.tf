module "offender-events-ui" {
  source     = "./modules/repository-collaborators"
  repository = "offender-events-ui"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "maintain"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-11"
    },
  ]
}
