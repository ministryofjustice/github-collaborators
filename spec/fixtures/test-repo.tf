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
      review_after = "2023-08-28"
    },
    {
      github_user  = "someuser2"
      permission   = "write"
      name         = "some user"
      email        = "test2@gmail.com"
      org          = "some org"
      reason       = "test"
      added_by     = "other user <otheruser@someemail.com"
      review_after = "2023-08-28"
    },
  ]
}