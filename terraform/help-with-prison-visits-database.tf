module "help-with-prison-visits-database" {
  source     = "./modules/repository-collaborators"
  repository = "help-with-prison-visits-database"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "push"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-20"
    },
  ]
}
