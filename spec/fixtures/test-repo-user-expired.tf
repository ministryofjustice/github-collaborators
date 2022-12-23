module "test-repo" {
  source     = "./modules/repository-collaborators"
  repository = "test-repo"
  collaborators = [
    {
      github_user  = "someuser1"
      permission   = "admin"
      name         = "some user"
      email        = "test1@gmail.com"
      org          = "some org"
      reason       = "test"
      added_by     = "other user <otheruser@someemail.com"
      review_after = "2002-08-28"
    },
  ]
}