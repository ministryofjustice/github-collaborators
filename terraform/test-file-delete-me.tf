module "test-file-delete-me" {
  source     = "./modules/repository-collaborators"
  repository = "test-file-delete-me"
  collaborators = [
    {
      github_user  = "test-file-delete-me"
      permission   = "push"
      name         = "test-file-delete-me"
      email        = "test-file-delete-me"
      org          = "test-file-delete-me"
      reason       = "test-file-delete-me"
      added_by     = "test-file-delete-me"
      review_after = "2022-01-14"
    },
  ]
}
