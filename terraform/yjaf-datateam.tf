module "yjaf-datateam" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-datateam"
  collaborators = [
    {
      github_user  = "sammohammeduk"
      permission   = "push"
      name         = "Sam Mohammed"
      email        = "sam.mohammed@necsws.com"
      org          = "NEC"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "antony.bishop@digital.justice.gov.uk"
      review_after = "2022-12-19"
    },
    {
      github_user  = "anntallis"
      permission   = "push"
      name         = "Ann Meads-Tallis"
      email        = "ann.meads-tallis@necsws.com"
      org          = "NEC"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "antony.bishop@digital.justice.gov.uk"
      review_after = "2022-12-19"
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
      github_user  = "InFlamesForever"
      permission   = "admin"
      name         = "Richard Came"
      email        = "richard.came@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding Tasks"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk"
      review_after = "2022-08-27"
    },
    {
      github_user  = "richardbradwell"
      permission   = "admin"
      name         = "Richard Bradwell"
      email        = "richard.bradwell@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding Tasks"
      added_by     = "Jo Harvey <joanna.harvey@necsws.com"
      review_after = "2022-10-05"
    },
  ]
}
