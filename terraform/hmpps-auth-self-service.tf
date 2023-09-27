module "hmpps-auth-self-service" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-auth-self-service"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "push"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-26"
    },
  ]
}
