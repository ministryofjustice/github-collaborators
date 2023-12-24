module "hmpps-approved-premises-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-approved-premises-api"
  collaborators = [
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
