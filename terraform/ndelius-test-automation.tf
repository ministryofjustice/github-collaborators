module "ndelius-test-automation" {
  source     = "./modules/repository-collaborators"
  repository = "ndelius-test-automation"
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
      github_user  = "mlaskowski4"
      permission   = "admin"
      name         = "Michal Laskowski"                                                                  #  The name of the person behind github_user
      email        = "mlaskowski@unilink.com"                                                            #  Their email address
      org          = "Unilink"                                                                           #  The organisation/entity they belong to
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS" #  Why is this person being granted access?
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-02-25"                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "peter-bcl"
      permission   = "admin"
      name         = "Peter Wilson"                                                                      #  The name of the person behind github_user
      email        = "pwilson@unilink.com"                                                               #  Their email address
      org          = "Unilink"                                                                           #  The organisation/entity they belong to
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS" #  Why is this person being granted access?
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-02-25"                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "unilinkuser-alexo"
      permission   = "admin"
      name         = "Alex Oyedele"                                                                      #  The name of the person behind github_user
      email        = "aoyedele@unilink.com"                                                              #  Their email address
      org          = "Unilink"                                                                           #  The organisation/entity they belong to
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS" #  Why is this person being granted access?
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-02-25"                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "ND070322"
      permission   = "admin"
      name         = "Neale Davison"                                                                     #  The name of the person behind github_user
      email        = "ndavison@unilink.com"                                                              #  Their email address
      org          = "Unilink"                                                                           #  The organisation/entity they belong to
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS" #  Why is this person being granted access?
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-02-25"                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
