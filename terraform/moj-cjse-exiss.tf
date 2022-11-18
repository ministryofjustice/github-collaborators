module "moj-cjse-exiss" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-exiss"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "Ben Pirt"
      email        = "ben@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-06-17"
    },
  ]
}
