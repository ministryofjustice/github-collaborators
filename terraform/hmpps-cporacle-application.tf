module "hmpps-cporacle-application" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-cporacle-application"
  collaborators = [
    {
      github_user  = "aliuk2012"
      permission   = "push"
      name         = "Alistair Laing"                                                                                               #  The name of the person behind github_user
      email        = "alistair.laing@adrocgroup.com"                                                                                #  Their email address
      org          = "Adroc Group"                                                                                                  #  The organisation/entity they belong to
      reason       = "Alistair needs access so that he can develop required code in CP Oracle to support urgent Day 1 deliverables" #  Why is this person being granted access?
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"                                     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-06-21"                                                                                                   #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "swestb"
      permission   = "admin"
      name         = "Stuart Westbrook"                                                                                                                      #  The name of the person behind github_user
      email        = "stuart.westbrook@adrocgroup.com"                                                                                                       #  Their email address
      org          = "Adroc Group"                                                                                                                           #  The organisation/entity they belong to
      reason       = "Stuart is a new member of the team and will require the same level of access to the repos as the rest of the developers in this group" #  Why is this person being granted access?
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"                                                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-05-21"                                                                                                                            #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "alreichfernandes"
      permission   = "push"
      name         = "Alreichv Fernandes"                                                                                                                      #  The name of the person behind github_user
      email        = "alreich.fernandes@mtcgroup.org.uk"                                                                                                       #  Their email address
      org          = "MTC Group"                                                                                                                           #  The organisation/entity they belong to
      reason       = "Access so that new member can develop required code in CP Oracle to support urgent Day 1 deliverables" #  Why is this person being granted access?
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"                                                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-07-11"                                                                                                                            #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
