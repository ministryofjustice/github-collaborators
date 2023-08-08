module "template-repository" {
  source     = "./modules/repository-collaborators"
  repository = "template-repository"
  collaborators = [
    {
      github_user  = "nickwalt01"
      permission   = "pull"
      name         = "nick walters"
      email        = "nick.walters@digital.justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "nick.walters@digital.justice.gov.uk"
      review_after = "2023-08-28"
    },
  ]
}
