module "hmeat" {
  source     = "./modules/repository-collaborators"
  repository = "hmeat"
  collaborators = [
    {
      github_user  = "arcturus-tom"
      permission   = "pull"
      name         = "Thomas Smith"
      email        = "Thomas.Smith@arcturussecurity.com"
      org          = "DTS Cyber Security"
      reason       = "perform vulnerability scans on Tribunals website repos"
      added_by     = "mark.butler@hmcts.net"
      review_after = "2024-06-28"
    },
  ]
}
