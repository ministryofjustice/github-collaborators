module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "hullcoastie"
      permission   = "push"
      name         = "John Broom"                                                                                  #  The name of the person behind github_user
      email        = "John.Broom@roctechnologies.com"                                                              #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "jamesashton-roc"
      permission   = "push"
      name         = "James Ashton"                                                                                #  The name of the person behind github_user
      email        = "James.Ashton@roctechnologies.com"                                                            #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "MMBroc"
      permission   = "push"
      name         = "Michael Bullen"                                                                              #  The name of the person behind github_user
      email        = "Michael.Bullen@roctechnologies.com"                                                          #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "md-roc"
      permission   = "push"
      name         = "Mittul Datani"                                                                               #  The name of the person behind github_user
      email        = "Mittul.Datani@roctechnologies.com"                                                           #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "craigygordon"
      permission   = "push"
      name         = "Craig Gordon"                                                                                #  The name of the person behind github_user
      email        = "Craig.Gordon@roctechnologies.com"                                                            #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "andylandroc"
      permission   = "push"
      name         = "Andy Land"                                                                                   #  The name of the person behind github_user
      email        = "Andy.Land@roctechnologies.com"                                                               #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "trudley"
      permission   = "push"
      name         = "Tom Rudley"                                                                                  #  The name of the person behind github_user
      email        = "Tom.Rudley@roctechnologies.com"                                                              #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "helenvickers-roc"
      permission   = "push"
      name         = "Helen Vickers"                                                                               #  The name of the person behind github_user
      email        = "Helen.Vickers@roctechnologies.com"                                                           #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "Tom-Whi"
      permission   = "push"
      name         = "Tom Whiteley"                                                                                #  The name of the person behind github_user
      email        = "Tom.Whiteley@roctechnologies.com"                                                            #  Their email address
      org          = "Roc Technologies"                                                                            #  The organisation/entity they belong to
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform" #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"                  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-11-01"                                                                                  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "agilisys-agardner"
      permission   = "push"
      name         = "Andrew Gardener"                                                            #  The name of the person behind github_user
      email        = "andrew.gardner@agilisys.co.uk"                                              #  Their email address
      org          = "Agilisys"                                                                   #  The organisation/entity they belong to
      reason       = "Get access to data-and-insights-hub on Modernisation Platform"              #  Why is this person being granted access?
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-02-23"                                                                 #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
