module "cicap" {
  source     = "./modules/repository-collaborators"
  repository = "cicap"
  collaborators = [
    {
      github_user  = "arcturus-tom"
      permission   = "pull"
      name         = "Thomas Smith"
      email        = "Thomas.Smith@arcturussecurity.com"
      org          = "DTS Cyber Security"
      reason       = "perform vulnerability scans on Tribunals website repos"
      added_by     = "mark.butler@hmcts.net"
      review_after = "2023-12-31"
    },
  ]
}
