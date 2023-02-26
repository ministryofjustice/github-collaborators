module "hmpps-delius-interventions-event-listener" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-delius-interventions-event-listener"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-27"
    },
  ]
}
