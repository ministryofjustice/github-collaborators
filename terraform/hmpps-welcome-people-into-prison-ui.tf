module "hmpps-welcome-people-into-prison-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-welcome-people-into-prison-ui"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "push"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-09"
    },
  ]
}
