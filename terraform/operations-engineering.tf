module "operations-engineering" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "Admin"
      name         = "Nick Walters"
      email        = "nick.walters@digital.justice.gov.uk"
      org          = "MoJ"
      reason       = "Test"
      added_by     = "Nick"
      review_after = "2023-07-25"
    },
  ]
}
