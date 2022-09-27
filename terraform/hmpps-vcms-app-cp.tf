module "hmpps-vcms-app-cp" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms-app-cp"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"                                                       #  The name of the person behind github_user
      email        = "simon.creasy@civica.co.uk"                                          #  Their email address
      org          = "Civica"                                                             #  The organisation/entity they belong to
      reason       = "Civica developer for Victims Case Management System"                #  Why is this person being granted access?
      added_by     = "Probation WebOps team, probation-webops@digital.justice.gov.uk"     #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-27"                                                         #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"                                                        #  The name of the person behind github_user
      email        = "simon.barnes@civica.co.uk"                                           #  Their email address
      org          = "Civica"                                                              #  The organisation/entity they belong to
      reason       = "Civica developer for Victims Case Management System"                 #  Why is this person being granted access?
      added_by     = "Probation WebOps team, probation-webops@digital.justice.gov.uk"      #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-27"                                                          #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "miriamgo-civica"
      permission   = "push"
      name         = "Miriam Gomez-Orozco"                                                  #  The name of the person behind github_user
      email        = "Miriam.Gomez-Orozco@civica.co.uk"                                     #  Their email address
      org          = "civica"                                                               #  The organisation/entity they belong to
      reason       = "Civica developer for Victims Case Management System"                  #  Why is this person being granted access?
      added_by     = "Probation WebOps team, probation-webops@digital.justice.gov.uk"       #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-27"                                                           #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
