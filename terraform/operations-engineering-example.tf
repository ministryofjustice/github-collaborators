module "operations-engineering-example" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering-example"
  collaborators = [
    {
      github_user  = "crushaforbes"
      permission   = "push"
      name         = "Crusha Forbes"
      email        = "crushaforbes@gmail.com"
      org          = "Testing"
      reason       = "Test new token works"
      added_by     = "tamsin.forbes@digital.justice.gov.uk"
      review_after = "2024-07-09"
    },
  ]
}
