module "hmpps-subject-access-request-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-subject-access-request-ui"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "admin"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-01-30"
    },
  ]
}
