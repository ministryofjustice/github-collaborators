module "staff-device-management-admin" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-admin"
  collaborators = [
    {
      github_user  = "JimGregory-CplusC"
      permission   = "admin"
      name         = "Jim Gregory"                   #  The name of the person behind github_user
      email        = "jgregory@sol-tec.com"          #  Their email address
      org          = "Sol-Tec"                       #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                    #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "HughSolTec"
      permission   = "admin"
      name         = "Hugh Dingwall"                 #  The name of the person behind github_user
      email        = "hdingwall@sol-tec.com"         #  Their email address
      org          = "Sol-Tec"                       #  The organisation/entity they belong to
      reason       = "PTTP Tech Team"                #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                    #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
