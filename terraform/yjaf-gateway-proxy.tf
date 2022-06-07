module "yjaf-gateway-proxy" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-gateway-proxy"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "Thomas Tipler - thomas.tipler@northgateps.com"
      review_after = "2022-12-25"
    },
    {
      github_user  = "InFlamesForever"
      permission   = "admin"
      name         = "Richard Came"
      email        = "richard.came@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding Tasks"
      added_by     = "Thomas Tipler - thomas.tipler@northgateps.com"
      review_after = "2022-12-25"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Thomas Tipler - thomas.tipler@northgateps.com"
      review_after = "2022-12-25"
    },
    {
      github_user  = "TomDover-NorthgatePS"
      permission   = "admin"
      name         = "Tom Dover"
      email        = "tom.dover@northgateps.com"
      org          = "NEC"
      reason       = "Need access to repo for coding tasks"
      added_by     = "Thomas Tipler - thomas.tipler@northgateps.com - Devops for northgate"
      review_after = "2022-12-31"
    },
    {
      github_user  = "stephenhobden"
      permission   = "push"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NEC"
      reason       = "Need access to repo for coding tasks"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2022-08-09"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC"
      reason       = "Part of the Northgate supplier team who are now NEC for the YJB YJAF system"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2022-12-31"
    },
    {
      github_user  = "jondent"
      permission   = "admin"
      name         = "Jon Dent"
      email        = "Jon.Dent@yjb.gov.uk"
      org          = "YJB"
      reason       = "Developer on gateway proxy development and rollout"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-14"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "YJB"
      reason       = "For work on the gateway-proxy project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-22"
    },
    {
      github_user  = "AndrewTRichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-26"
    },
  ]
}
