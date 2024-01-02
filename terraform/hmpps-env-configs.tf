module "hmpps-env-configs" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-env-configs"
  collaborators = [
    {
      github_user  = "peter-bcl"
      permission   = "push"
      name         = "Peter Wilson"
      email        = "pwilson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "marcus.aspin@digital.justice.gov.uk"
      review_after = "2024-06-25"
    },
  ]
}
