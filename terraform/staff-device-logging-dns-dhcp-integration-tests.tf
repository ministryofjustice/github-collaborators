module "staff-device-logging-dns-dhcp-integration-tests" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-logging-dns-dhcp-integration-tests"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
    {
      github_user  = "emileswarts"
      permission   = "pull"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-04-14"
    },
  ]
}
