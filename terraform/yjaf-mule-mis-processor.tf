module "yjaf-mule-mis-processor" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-mule-mis-processor"
  collaborators = [
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Want to amend logging settings for all microservices"
      added_by     = "Mick.Ewers@yjb.gov.uk"
      review_after = "2024-07-09"
    },
  ]
}
