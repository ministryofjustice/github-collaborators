module "check-financial-eligibility-partner" {
  source     = "./modules/repository-collaborators"
  repository = "check-financial-eligibility-partner"
  collaborators = [
    {
      github_user  = "bsi0714"
      permission   = "admin"
      name         = "daniel elliott"
      email        = "bsi.security.tester2@digital.justice.gov.uk"
      org          = "bsi"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-10"
    },
  ]
}
