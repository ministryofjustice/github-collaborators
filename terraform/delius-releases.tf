module "delius-releases" {
  source     = "./modules/repository-collaborators"
  repository = "delius-releases"
  collaborators = [
    {
      github_user  = "MichaelWetherallBCL"
      permission   = "admin"
      name         = "Michael Wetherall"                                                                 #  The name of the person behind github_user
      email        = "mwetherall@unilink.com"                                                            #  Their email address
      org          = "Unilink"                                                                           #  The organisation/entity they belong to
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS" #  Why is this person being granted access?
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-09-22"                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
