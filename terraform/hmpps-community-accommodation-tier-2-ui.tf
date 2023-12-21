module "hmpps-community-accommodation-tier-2-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-community-accommodation-tier-2-ui"
  collaborators = [
    {
      github_user  = "jleightonncc"
      permission   = "pull"
      name         = "Jason Leighton"
      email        = "jason.leighton@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "harriet.horobin-worley@digital.justice.gov.uk"
      review_after = "2024-06-20"
    },
    {
      github_user  = "jandersonncc"
      permission   = "pull"
      name         = "Joseph Anderson"
      email        = "joseph.anderson@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "harriet.horobin-worley@digital.justice.gov.uk"
      review_after = "2023-12-23"
    },
  ]
}
