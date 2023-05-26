module "offender-events-ui" {
  source     = "./modules/repository-collaborators"
  repository = "offender-events-ui"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "maintain"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-24"
    },
  ]
}
