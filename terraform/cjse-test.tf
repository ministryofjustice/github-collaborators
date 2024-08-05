module "cjse-test" {
  source     = "./modules/repository-collaborators"
  repository = "cjse-test"
  collaborators = [
    {
      github_user  = "zimboflyman"
      permission   = "admin"
      name         = "Shane Vanleeuwen"
      email        = "shane.vanleeuwen@version1.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "pawellas"
      permission   = "admin"
      name         = "Pawel Laskowski"
      email        = "pawel.laskowski@version1.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
  ]
}
