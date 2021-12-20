module "yjaf-datateam" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-datateam"
  collaborators = [
    {
      github_user  = "SamMohammeduk"
      permission   = "push"
      name         = "Sam Mohammed"
      email        = "sam.mohammed@necsws.com"
      org          = "NEC"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "joanna.harvey@necsws.com"
      review_after = "2022-12-19"
    },
    {
      github_user  = "anntallis"
      permission   = "push"
      name         = "Ann Meads-Tallis"
      email        = "ann.meads-tallis@necsws.com"
      org          = "NEC"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "joanna.harvey@necsws.com"
      review_after = "2022-12-19"
    },
  ]
}
