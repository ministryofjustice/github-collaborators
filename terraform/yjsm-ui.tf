module "yjsm-ui" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-ui"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "griffinjuknps"
      permission   = "admin"
      name         = "Jeremy Griffin"
      email        = "jeremy.griffin@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "TomDover-NorthgatePS"
      permission   = "admin"
      name         = "Tom Dover"
      email        = "tom.dover@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "djv72"
      permission   = "push"
      name         = "David Vincent"
      email        = "David.Vincent@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk"
      review_after = "2021-12-31"
    },
    {
      github_user  = "MylesW123"
      permission   = "push"
      name         = "Myles Waller"
      email        = "Myles.Waller@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk"
      review_after = "2021-12-31"
    },
    {
      github_user  = "brbaje-dev"
      permission   = "admin"
      name         = "Ben Bajek"
      email        = "ben.bajek@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@northgateps.com"
      review_after = "2022-12-31"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@northgateps.com"
      review_after = "2022-12-31"
    },
    {
      github_user  = "jondent"
      permission   = "push"
      name         = "Jon Dent"
      email        = "jon.dent@yjb.gov.uk"
      org          = "Youth Justice Board"
      reason       = "Technical Assurance Architect (managed service)"
      added_by     = "Jake Mulley (MOJ)"
      review_after = "2022-01-31"
    },
  ]
}
