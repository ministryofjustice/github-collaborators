module "prisoner-content-hub-feedback-exporter" {
  source     = "./modules/repository-collaborators"
  repository = "prisoner-content-hub-feedback-exporter"
  collaborators = [
    {
      github_user  = "shaun-bsi"
      permission   = "push"
      name         = "**shaun dundavan**"
      email        = "shaun.dundavan@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-13"
    },
  ]
}
