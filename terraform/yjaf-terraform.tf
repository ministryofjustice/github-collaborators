module "yjaf-terraform" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-terraform"
  collaborators = [
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2025-03-14"
    },
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2025-03-14"
    },
    {
      github_user  = "davidseekins"
      permission   = "admin"
      name         = "David Seekins"
      email        = "david.seekins@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2025-03-14"
    },
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Gregory Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-05-23"
    }
  ]
}
