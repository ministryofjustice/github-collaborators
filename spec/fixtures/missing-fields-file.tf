module "some-repo" {
  source     = "./modules/repository-collaborators"
  repository = "some.repo"
  collaborators = [
    {
      github_user  = "someuser"
      permission   = "maintain"
      name         = ""
      email        = ""
      org          = ""
      reason       = ""
      added_by     = ""
      review_after = ""
    },
  ]
}
