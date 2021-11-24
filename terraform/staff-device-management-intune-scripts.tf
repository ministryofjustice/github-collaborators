module "staff-device-management-intune-scripts" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-intune-scripts"
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
    {
      github_user  = "RyanLWilliams"
      permission   = "push"
      name         = "Ryan Williams"                 #  The name of the person behind github_user
      email        = "rwilliams@sol-tec.com"         #  Their email address
      org          = "Sol-Tec"                       #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                    #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "LiliNedeleva"
      permission   = "admin"
      name         = "Lili Nedeleva"         #  The name of the person behind github_user
      email        = "lnedeleva@sol-tec.com" #  Their email address
      org          = "Sol-Tec"               #  The organisation/entity they belong to
      reason       = "PTTP Tech team"        #  Why is this person being granted access?
      added_by     = "jgregory@sol-tec.com"  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"            #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "calkin"
      permission   = "push"
      name         = "Josh Calkin"          #  The name of the person behind github_user
      email        = "jcalkin@sol-tec.com"  #  Their email address
      org          = "Sol-Tec"              #  The organisation/entity they belong to
      reason       = "PTTP Tech team"       #  Why is this person being granted access?
      added_by     = "jgregory@sol-tec.com" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"           #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "mahmoudziadacc"
      permission   = "push"
      name         = "Mahmoud Ziada"                     #  The name of the person behind github_user
      email        = "mahmoud.ziada@contentandcloud.com" #  Their email address
      org          = "Content+Cloud"                     #  The organisation/entity they belong to
      reason       = "PTTP Tech team"                    #  Why is this person being granted access?
      added_by     = "jgregory@sol-tec.com"              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
