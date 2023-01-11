module "operations-engineering" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering"
  collaborators = [
    {
      github_user  = "fedf"
      permission   = "maintain"
      name         = "nick"
      email        = "nick.walter@justice.gov.uk"
      org          = "moj"
      reason       = "testing"
      added_by     = "ben"
      review_after = "2023-10-10"
    },
  ]
}
