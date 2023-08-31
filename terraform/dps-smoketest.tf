module "dps-smoketest" {
  source     = "./modules/repository-collaborators"
  repository = "dps-smoketest"
  collaborators = [
    {
      github_user  = "rodonnell1-bsi"
      permission   = "push"
      name         = "richard odonnell"
      email        = "richard.odonnell.testing1@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "IT Health Check"
      added_by     = "hari.chintala@digital.justice.gov.uk"
      review_after = "2023-08-30"
    },
  ]
}
