module "yjaf-poc-app" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-poc-app"
  collaborators = [
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "andrew.richards1@necsws.com"
      org          = "NEC SWS"
      reason       = "Existing developer"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-03-01"
    },
  ]
}
