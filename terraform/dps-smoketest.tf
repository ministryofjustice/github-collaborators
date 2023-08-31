module "dps-smoketest" {
  source     = "./modules/repository-collaborators"
  repository = "dps-smoketest"
  collaborators = [
    {
      github_user  = "joe-bsi"
      permission   = "push"
      name         = "joe beauchamp"
      email        = "joe.beauchamp.bsi@gmail.com"
      org          = "digital-prison-reporting"
      reason       = "IT Health Check"
      added_by     = "hari.chintala@digital.justice.gov.uk"
      review_after = "2023-08-30"
    },
  ]
}
