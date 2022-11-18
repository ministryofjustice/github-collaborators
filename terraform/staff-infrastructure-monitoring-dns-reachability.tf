module "staff-infrastructure-monitoring-dns-reachability" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-dns-reachability"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-16"
    },
  ]
}
