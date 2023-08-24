module "digital-prison-reporting-jobs" {
  source     = "./modules/repository-collaborators"
  repository = "digital-prison-reporting-jobs"
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
    {
      github_user  = "shaun-bsi"
      permission   = "push"
      name         = "Shaun Dundavan"
      email        = "shaun.dundavan@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "IT Health Check"
      added_by     = "hari.chintala@digital.justice.gov.uk"
      review_after = "2024-02-26"
    },
  ]
}
