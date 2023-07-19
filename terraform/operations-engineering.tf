module "operations-engineering" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering"
  collaborators = [
    {
      github_user  = "nickwalt01"
      permission   = "pull"
      name         = "nick"
      email        = "nick@digital.com"
      org          = "test"
      reason       = "test"
      added_by     = "ben.ashton@digital.justice.gov.uk"
      review_after = "2024-07-19"
    },
  ]
}
