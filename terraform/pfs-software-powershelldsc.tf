module "pfs-software-powershelldsc" {
  source     = "./modules/repository-collaborators"
  repository = "pfs-software-powershelldsc"
  collaborators = [
    {
      github_user  = "nathanials"
      permission   = "admin"
      name         = "Nathanials Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on new modernization platform for Unilink services"
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2024-07-30"
    },
  ]
}
