module "hmpps-delius-pipelines" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-delius-pipelines"
  collaborators = [
    {
      github_user  = "peter-bcl"
      permission   = "push"
      name         = "Peter Wilson"
      email        = "pwilson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "marcus.aspin@digital.justice.gov.uk"
      review_after = "2023-12-28"
    },
  ]
}
