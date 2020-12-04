module "YJAF-POC-APP" {
  source     = "./modules/repository-collaborators"
  repository = "YJAF-POC-APP"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
