module "hmpps-engineering-accelerator-team" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-accelerator-team"
  collaborators = [
    {
      github_user  = "shaun-bsi"
      permission   = "pull"
      name         = "**shaun dundavan**"
      email        = "shaun.dundavan@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-12"
    },
  ]
}
