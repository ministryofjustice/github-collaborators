module "delius" {
  source     = "./modules/repository-collaborators"
  repository = "delius"
  collaborators = [
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
      github_user  = "duncancrawford"
      permission   = "read"
      name         = "Duncan Crawford"                                                                                   #  The name of the person behind github_user
      email        = "Duncan.Crawford@digital.justice.gov.uk"                                                            #  Their email address
      org          = "Equal Experts"                                                                                     #  The organisation/entity they belong to
      reason       = "Technical Architect working on Delius"                                                             #  Why is this person being granted access?
      added_by     = "Jake Mulley on behalf of Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
