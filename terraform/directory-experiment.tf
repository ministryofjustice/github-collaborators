module "directory-experiment" {
  source     = "./modules/repository-collaborators"
  repository = "directory-experiment"
  collaborators = [
    {
      github_user  = "Ethan-McDowall"
      permission   = "push"
      name         = "Ethan McDowall"                                                                                                                      #  The name of the person behind github_user
      email        = "ethan.mcdowall@digital.justice.gov.uk"                                                                                                       #  Their email address
      org          = "MoJ"                                                                                                                           #  The organisation/entity they belong to
      reason       = "Interaction Designer - needs access to edit the prototype for the Cross Justice project: ELSA" #  Why is this person being granted access?
      added_by     = "David Silva, david.dasilva@digital.justice.gov.uk"                                                              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-04-01"                                                                                                                            #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
