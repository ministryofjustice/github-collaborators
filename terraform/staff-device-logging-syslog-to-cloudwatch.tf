module "staff-device-logging-syslog-to-cloudwatch" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-logging-syslog-to-cloudwatch"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-15"
    },
  ]
}
