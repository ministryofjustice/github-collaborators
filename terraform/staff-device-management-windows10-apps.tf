module "staff-device-management-windows10-apps" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-windows10-apps"
  collaborators = [
    {
      github_user  = "cyrusirandoust"
      permission   = "push"
      name         = ""  #  The name of the person behind github_user
      email        = ""  #  Their email address
      org          = ""  #  The organisation/entity they belong to
      reason       = ""  #  Why is this person being granted access?
      added_by     = ""  #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = ""  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "JimGregory-SolTec"
      permission   = "admin"
      name         = ""  #  The name of the person behind github_user
      email        = ""  #  Their email address
      org          = ""  #  The organisation/entity they belong to
      reason       = ""  #  Why is this person being granted access?
      added_by     = ""  #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = ""  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "HughSolTec"
      permission   = "admin"
      name         = ""  #  The name of the person behind github_user
      email        = ""  #  Their email address
      org          = ""  #  The organisation/entity they belong to
      reason       = ""  #  Why is this person being granted access?
      added_by     = ""  #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = ""  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
