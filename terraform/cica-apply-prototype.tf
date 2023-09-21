module "cica-apply-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "cica-apply-prototype"
  collaborators = [
    {
      github_user  = "bsi0714"
      permission   = "push"
      name         = "daniel elliott"
      email        = "daniel.elliott@bsigroup.com"
      org          = "bsi"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-20"
    },
  ]
}
