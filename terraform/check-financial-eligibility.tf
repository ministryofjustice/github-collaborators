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
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-04"
    },
  ]
}
