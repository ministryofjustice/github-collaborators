module "hmpps-breach-notice-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-breach-notice-ui"
  collaborators = [
    {
      github_user  = "peter-bcl"
      permission   = "push"
      name         = "Peter Wilson"
      email        = "pwilson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "marcus.aspin@digital.justice.gov.uk"
      review_after = "2025-06-01"
    },
  ]
}
