module "c100-application-deploy" {
  source     = "./modules/repository-collaborators"
  repository = "c100-application-deploy"
  collaborators = [
    {
      github_user  = "nick"
      permission   = "maintain"
      name         = "nick walters"
      email        = "nick.walter@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "nick"
      review_after = "2023-10-10"
    },
  ]
}
