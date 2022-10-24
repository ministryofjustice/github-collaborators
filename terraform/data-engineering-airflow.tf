module "data-engineering-airflow" {
  source     = "./modules/repository-collaborators"
  repository = "data-engineering-airflow"
  collaborators = [
    {
      github_user  = "Morspen"
      permission   = "push"
      name         = "Stuart Morrison"                          #  The name of the person behind github_user
      email        = "stuart.morrison@nccgroup.com"             #  Their email address
      org          = "NCC Group"                                #  The organisation/entity they belong to
      reason       = "Development"                              #  Why is this person being granted access?
      added_by     = "Ross Jones <Ross.Jones@justice.gov.uk>"   #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-04-23"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
