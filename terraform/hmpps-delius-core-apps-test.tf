module "hmpps-delius-core-apps-test" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-delius-core-apps-test"
  collaborators = [
    {
      github_user  = "mlaskowski4"
      permission   = "push"
      name         = "Michal Laskowski"
      email        = "mlaskowski@unilink.com"
      org          = "Unilink"
      reason       = "Unilink need access to github repos for development"
      added_by     = "probation-webops@digital.justice.gov.uk"
      review_after = "2025-02-27"
    },
  ]
}
