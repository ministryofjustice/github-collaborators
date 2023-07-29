module "digital-prison-reporting-transfer-component" {
  source     = "./modules/repository-collaborators"
  repository = "digital-prison-reporting-transfer-component"
  collaborators = [
    {
      github_user  = "rodonnell1-bsi"
      permission   = "maintain"
      name         = "richard odonnell"
      email        = "[richard.odonnell.testing1@bsigroup.com](mailto:richard.odonnell.testing1@bsigroup.com)"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-27"
    },
  ]
}
