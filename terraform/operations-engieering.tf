module "operations-engieering" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engieering"
  collaborators = [
    {
      github_user  = "some-radmon-user-%43221"
      permission   = "maintain"
      name         = "nick walters"
      email        = "nick.walter@justice.gov.uk"
      org          = "moj"
      reason       = "testing"
      added_by     = "Ben Ashton ben.ashton@digital.justice.gov.uk"
      review_after = "2023-10-10"
    },
  ]
}
