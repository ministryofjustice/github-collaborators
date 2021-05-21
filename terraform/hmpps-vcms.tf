module "hmpps-vcms" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "maintain"
      name         = "Simon Creasy"                                                                                           #  The name of the person behind github_user
      email        = "simon.creasy@civica.co.uk"                                                                              #  Their email address
      org          = "Civica"                                                                                                 #  The organisation/entity they belong to
      reason       = "Simon is one of the Civica developers that helps the development of the Victims Case Management System" #  Why is this person being granted access?
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"                               #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-05-21"                                                                                             #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
