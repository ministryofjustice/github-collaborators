module "testing-external-collaborators" {
  source     = "./modules/repository-collaborators"
  repository = "testing-external-collaborators"
  collaborators = [
    {
      github_user  = "DangerDawson"
      permission   = "push"
      name         = ""
      email        = ""
      org          = ""
      added_by     = ""
      reason       = ""
      review_after = ""
    },
  ]
}
