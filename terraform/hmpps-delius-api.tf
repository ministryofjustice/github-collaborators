module "hmpps-delius-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-delius-api"
  collaborators = [
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
  ]
}
