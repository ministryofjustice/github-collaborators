module "staff-infrastructure-monitoring-snmpexporter" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-snmpexporter"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
  ]
}
