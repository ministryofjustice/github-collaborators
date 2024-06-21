module "hmpps-ndelius-rbac" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-ndelius-rbac"
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
