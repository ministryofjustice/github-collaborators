module "cjs-dashboard" {
  source     = "./modules/repository-collaborators"
  repository = "cjs-dashboard"
  collaborators = [
    {
      github_user  = "katharine-breeze-desnz"
      permission   = "pull"
      name         = "Katharine Breeze"
      email        = "katharine.breeze2@energysecurity.gov.uk"
      org          = "desnz"
      reason       = "To be able to access some code that they wrote before leaving the MoJ."
      added_by     = "laura.knowles1@justice.gov.uk"
      review_after = "2025-03-14"
    },
  ]
}
