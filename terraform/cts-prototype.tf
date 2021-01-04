module "cts-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "cts-prototype"
  collaborators = [
    {
      github_user  = "digitalali-moj"
      permission   = "admin"
      name         = "Javid Ali" #  The name of the person behind github_user
      email        = "javid.ali@digital.justice.gov.uk" #  Their email address
      org          = "Ministry of Justice" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "Staff Tools & Services <staffservices@digital.justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
