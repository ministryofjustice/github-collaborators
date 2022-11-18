module "dso-infra-azure-ad" {
  source     = "./modules/repository-collaborators"
  repository = "dso-infra-azure-ad"
  collaborators = [
    {
      github_user  = "SimonGivan"
      permission   = "admin"
      name         = "Simon Givan"
      email        = "s.givan@kainos.com"
      org          = "Kainos"                                          
      reason       = "Approved by DSO team to add new users into Azure"
      added_by     = "Jake Mulley <jake.mulley@digital.justice.gov.uk>"
      review_after = "2022-12-31"                                      
    },
  ]
}
