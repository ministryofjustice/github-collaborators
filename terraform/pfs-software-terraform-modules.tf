module "pfs-software-terraform-modules" {
  source     = "./modules/repository-collaborators"
  repository = "pfs-software-terraform-modules"
  collaborators = [
    {
      github_user  = "nathanials"
      permission   = "admin"
      name         = "Nathanials Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on transfering code from a kainos owned repo to an MOJ owned repo for Jenkins"
      added_by     = "jonathan.houston@justice.gov.uk"
      review_after = "2025-07-25"
    },
    {
      github_user  = "simongivan"
      permission   = "admin"
      name         = "Simon Givan"
      email        = "s.givan@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on transfering code from a kainos owned repo to an MOJ owned repo"
      added_by     = "jonathan.houston@justice.gov.uk"
      review_after = "2025-07-25"
    },
    {
      github_user  = "dmeehankainos"
      permission   = "admin"
      name         = "Darren Meehan"
      email        = "darren.meehan@kainos.com"
      org          = "Kainos"
      reason       = "Kainos is working on new modernization platform for Unilink services"
      added_by     = "federico.staiano1@justice.gov.uk"
      review_after = "2025-07-25"
    },
  ]
}
