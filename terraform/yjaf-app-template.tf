module "yjaf-app-template" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-app-template"
  collaborators = [
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "andrew.richards1@necsws.com"
      org          = "NEC SWS"
      reason       = "Existing developer"
      added_by     = "Mick.Ewers@yjb.gov.uk"
      review_after = "2024-06-01"
    },
  ]
}
