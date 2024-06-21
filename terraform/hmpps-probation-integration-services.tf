module "hmpps-probation-integration-services" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-probation-integration-services"
  collaborators = [
    {
      github_user  = "mlaskowski4"
      permission   = "push"
      name         = "Michal Laskowski"
      email        = "mlaskowski@unilink.com"
      org          = "Unilink"
      reason       = "To submit pull requests to the integration repo"
      added_by     = "marcus.aspin@digital.justice.gov.uk"
      review_after = "2025-06-01"
    },
  ]
}
