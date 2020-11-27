module "HMPPS-propose-a-new-digital-service" {
  source     = "./modules/repository-collaborators"
  repository = "HMPPS-propose-a-new-digital-service"
  collaborators = [
    {
      github_user  = "dominion79"
      permission   = "admin"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
