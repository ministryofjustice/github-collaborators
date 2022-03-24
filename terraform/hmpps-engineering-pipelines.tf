module "hmpps-engineering-pipelines" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-pipelines"
  collaborators = [
    {
      github_user  = "swestb"
      permission   = "admin"
      name         = "Stuart Westbrook"                                                                                                                      #  The name of the person behind github_user
      email        = "stuart.westbrook@adrocgroup.com"                                                                                                       #  Their email address
      org          = "Adroc Group"                                                                                                                           #  The organisation/entity they belong to
      reason       = "Stuart is a new member of the team and will require the same level of access to the repos as the rest of the developers in this group" #  Why is this person being granted access?
      added_by     = "Maximillian Lakanu, maximillian.lakanu@digital.justice.gov.uk"                                                                         #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-09-01"                                                                                                                            #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
