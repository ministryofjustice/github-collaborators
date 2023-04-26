module "laa-estimate-financial-eligibility-for-legal-aid" {
  source     = "./modules/repository-collaborators"
  repository = "laa-estimate-financial-eligibility-for-legal-aid"
  collaborators = [
    {
      github_user  = "bsi0714"
      permission   = "pull"
      name         = "Daniel Elliott"
      email        = "bsi.security.tester2@digital.justice.gov.uk"
      org          = "BSI"
      reason       = "security Testing/ITHC"
      added_by     = "william.clarke@digital.justice.gov.uk"
      review_after = "2023-06-26"
    },
  ]
}
