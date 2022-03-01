module "staff-device-management-windows10-mass-storage-controls" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-windows10-mass-storage-controls"
  collaborators = [
    {
      github_user  = "JimGregory-CplusC"
      permission   = "admin"
      name         = "Jim Gregory"                     #  The name of the person behind github_user
      email        = "jim.gregory@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"               #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                  #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"   #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                      #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "RyanLWilliams"
      permission   = "push"
      name         = "Ryan Williams"                     #  The name of the person behind github_user
      email        = "ryan.williams@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"                 #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                    #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "LiliNedeleva"
      permission   = "admin"
      name         = "Lili Nedeleva"                     #  The name of the person behind github_user
      email        = "lili.nedeleva@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"                 #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                    #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "calkin"
      permission   = "push"
      name         = "Josh Calkin"                     #  The name of the person behind github_user
      email        = "josh.calkin@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"               #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                  #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"   #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                      #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "cyrusirandoust"
      permission   = "push"
      name         = "Cyrus Irandoust"                     #  The name of the person behind github_user
      email        = "cyrus.irandoust@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"                   #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                      #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"       #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                          #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
