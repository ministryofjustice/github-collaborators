module "pfs-software-services_terraform" {
  source     = "./modules/repository-collaborators"
  repository = "pfs-software-services_terraform"
  collaborators = [
    {
      github_user  = "simongivan"
      permission   = "admin"
      name         = "Simon Givan"
      email        = "s.givan@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on transfering code from a kainos owned repo to an MOJ owned repo"
      added_by     = "Incell Infrastructure team, federico.staiano1@justice.gov.uk"
      review_after = "2023-09-14"
    },
    {
      github_user  = "nathanials"
      permission   = "admin"
      name         = "Nathanials Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on transfering code from a kainos owned repo to an MOJ owned repo for Jenkins"
      added_by     = "Incell Infrastructure team, federico.staiano1@justice.gov.uk"
      review_after = "2023-03-18"
    },
  ]
}
