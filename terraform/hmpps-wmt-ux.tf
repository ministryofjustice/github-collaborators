module "hmpps-wmt-ux" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-wmt-ux"
  collaborators = [
    {
      github_user  = "tswann"
      permission   = "admin"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "chrisisk"
      permission   = "push"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "andrew-js-wright"
      permission   = "push"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "stevenadams"
      permission   = "push"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "dconey646"
      permission   = "push"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "caoimheb"
      permission   = "push"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
