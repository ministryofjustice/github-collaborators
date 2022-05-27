module "yjaf-transitions" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-transitions"
  collaborators = [
    {
      github_user  = "InFlamesForever"
      permission   = "admin"
      name         = "Richard Came"
      email        = "richard.came@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "richardbradwell"
      permission   = "admin"
      name         = "Richard Bradwell"
      email        = "richard.bradwell@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "TomDover-NorthgatePS"
      permission   = "admin"
      name         = "Tom Dover"
      email        = "tom.dover@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on pipeline for deployment of microservice"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-24"
    },
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Gregory Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on pipeline for deployment of microservice"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-24"
    },
    {
      github_user  = "craig-ashford"
      permission   = "maintain"
      name         = "Craig Ashford"
      email        = "craig.ashford@necsws.com"
      org          = "NEC SWS"
      reason       = "New front end developer on YJAF team"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2022-11-19"
    },
    {
      github_user  = "djv72"
      permission   = "push"
      name         = "David Vincent"
      email        = "david.vincent@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding Tasks"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk"
      review_after = "2022-11-19"
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
