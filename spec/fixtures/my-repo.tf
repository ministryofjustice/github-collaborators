module "my-repo" {
  source     = "./modules/repository-collaborators"
  repository = "my.repo"
  collaborators = [
    {
      github_user  = "digitalronin"
      permission   = "admin"
      name         = ""
      email        = ""
      org          = ""
      reason       = ""
      added_by     = ""
      review_after = ""
    },
  ]
}
