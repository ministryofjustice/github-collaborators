module "dso-infra-azure-ad" {
  source     = "./modules/repository-collaborators"
  repository = "dso-infra-azure-ad"
  collaborators = [
    {
      github_user  = "simongivan"
      permission   = "admin"
      name         = "Simon Givan"
      email        = "s.givan@kainos.com"
      org          = "Kainos"
      reason       = "Approved by DSO team to add new users into Azure"
      added_by     = "Jake Mulley <jake.mulley@digital.justice.gov.uk>"
      review_after = "2023-06-31"
    },
  ]
}
