module "staff-device-logging-dns-dhcp-integration-tests" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-logging-dns-dhcp-integration-tests"
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
