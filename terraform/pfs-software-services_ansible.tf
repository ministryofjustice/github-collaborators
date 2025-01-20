module "pfs-software-services_ansible" {
  source     = "./modules/repository-collaborators"
  repository = "pfs-software-services_ansible"
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
      review_after = "2025-01-26"
    },
  ]
}
