module "pfs-software-partialdsc" {
  source     = "./modules/repository-collaborators"
  repository = "pfs-software-partialdsc"
  collaborators = [
    {
      github_user  = "nathanials"
      permission   = "admin"
      name         = "Nathanials Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working new modernization platform for nilink services"
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2024-02-01"
    },
    {
      github_user  = "simongivan"
      permission   = "admin"
      name         = "Simon Givan"
      email        = "s.givan@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working new modernization platform for nilink services"
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2024-02-01"
    },
    {
      github_user  = "mistersk"
      permission   = "admin"
      name         = "Sanya Khasenye"
      email        = "sanyak@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working new modernization platform for nilink services"
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2024-02-01"
    },
  ]
}
