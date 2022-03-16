module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "simperialtd"
      permission   = "push"
      name         = "Sergio Imperial"                                                                #  The name of the person behind github_user
      email        = "sergio.imperial@techdata.com"                                                   #  Their email address
      org          = "TechData"                                                                       #  The organisation/entity they belong to
      reason       = "TechData are building HMPPS Equip infrastructure on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-08-01"                                                                     #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "vadisalar"
      permission   = "push"
      name         = "Ravi Vadisala"                                                                  #  The name of the person behind github_user
      email        = "ravi.vadisala@techdata.com"                                                     #  Their email address
      org          = "TechData"                                                                       #  The organisation/entity they belong to
      reason       = "TechData are building HMPPS Equip infrastructure on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-08-01"                                                                     #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "hullcoastie"
      permission   = "push"
      name         = "John Broom"                                                                  #  The name of the person behind github_user
      email        = "John.Broom@roctechnologies.com"                                                     #  Their email address
      org          = "Roc Technologies"                                                                       #  The organisation/entity they belong to
      reason       = "Roc are building and supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-08-01"                                                                     #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
