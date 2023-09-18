module "laa_govuk_notify_orchestrator" {
  source     = "./modules/repository-collaborators"
  repository = "laa_govuk_notify_orchestrator"
  collaborators = [
    {
      github_user  = "benmillar-cgi"
      permission   = "admin"
      name         = "ben millar"
      email        = "ben.millar@digital.justice.gov.uk"
      org          = "cgi"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-15"
    },
  ]
}
