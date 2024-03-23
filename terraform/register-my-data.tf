module "register-my-data" {
  source     = "./modules/repository-collaborators"
  repository = "register-my-data"
  collaborators = [
    {
      github_user  = "ttipler"
      permission   = "pull"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-09-25"
    },
  ]
}
