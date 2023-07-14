module "digital-prison-reporting-test-harness" {
  source     = "./modules/repository-collaborators"
  repository = "digital-prison-reporting-test-harness"
  collaborators = [
    {
      github_user  = "shaun-bsi"
      permission   = "admin"
      name         = "**shaun dundavan**"
      email        = "shaun.dundavan@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-12"
    },
  ]
}
