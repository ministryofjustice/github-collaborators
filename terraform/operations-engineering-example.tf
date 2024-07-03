module "operations-engineering-example" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering-example"
  collaborators = [
    {
      github_user  = "crushaforbes"
      permission   = "push"
      name         = "Tamsin Test Forbes"
      email        = "crushaforbes@gmail.com"
      org          = "testing"
      reason       = "To test the new token works"
      added_by     = "tamsin.forbes@digital.justice.gov.uk"
      review_after = "2025-01-05"
    },
  ]
}
