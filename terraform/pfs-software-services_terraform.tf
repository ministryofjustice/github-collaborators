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
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2023-12-14"
    },
    {
      github_user  = "nathanials"
      permission   = "admin"
      name         = "Nathanials Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on transfering code from a kainos owned repo to an MOJ owned repo for Jenkins"
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2023-12-14"
    },
  ]
}
