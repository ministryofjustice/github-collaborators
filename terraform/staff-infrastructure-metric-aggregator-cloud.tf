module "staff-infrastructure-metric-aggregator-cloud" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-metric-aggregator-cloud"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "maintain"
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-19"
    },
  ]
}
