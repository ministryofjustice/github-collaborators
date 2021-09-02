module "ben" {
  source     = "./modules/repository-collaborators"
  repository = "ben"
  collaborators = [
    {
      github_user  = "bendashton"
      permission   = "admin"
      name         = "Ben Ashton"
      email        = "test1@gmail.com"
      org          = "AL"
      reason       = "Test"
      added_by     = "Ben Ashton <ben@automationlogic.com"
      review_after = "2021-08-28"
    },
    {
      github_user  = "beno"
      permission   = "admin"
      name         = "Ben Ashton"
      email        = "test2@gmail.com"
      org          = "AL"
      reason       = "Test"
      added_by     = "Ben Ashton <ben@automationlogic.com"
      review_after = "2021-08-28"
    },
  ]
}