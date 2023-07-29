module "digital-prison-reporting-transfer-component" {
  source     = "./modules/repository-collaborators"
  repository = "digital-prison-reporting-transfer-component"
  collaborators = [
    {
      github_user  = "joe-bsi"
      permission   = "maintain"
      name         = "joe beauchamp"
      email        = "[joe.beauchamp.bsi@gmail.com](mailto:joe.beauchamp.bsi@gmail.com)"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-27"
    },
  ]
}
