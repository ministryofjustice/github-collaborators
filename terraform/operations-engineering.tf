module "operations-engineering" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering"
  collaborators = [
    {
      github_user  = "nickwalt01"
      permission   = "maintain"
      name         = "nick"
      email        = "nick.walter@justice.gov.uk"
      org          = "moj"
      reason       = "testing"
      added_by     = "nick"
      review_after = "10-10-2022"
    },
  ]
}
