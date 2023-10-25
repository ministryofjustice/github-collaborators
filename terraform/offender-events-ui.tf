module "offender-events-ui" {
  source     = "./modules/repository-collaborators"
  repository = "offender-events-ui"
  collaborators = [
    {
      github_user  = "chubberlisk"
      permission   = "maintain"
      name         = "wen ting wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-01-23"
    },
  ]
}
