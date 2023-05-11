module "check-financial-eligibility" {
  source     = "./modules/repository-collaborators"
  repository = "check-financial-eligibility"
  collaborators = [
    {
      github_user  = "bsi0714"
      permission   = "maintain"
      name         = "daniel elliott"
      email        = "bsi.security.tester2@digital.justice.gov.uk"
      org          = "bsi"
      reason       = "security Testing/ITHC"
      added_by     = "william.clarke@digital.justice.gov.uk"
      review_after = "2023-06-26"
    },
  ]
}
