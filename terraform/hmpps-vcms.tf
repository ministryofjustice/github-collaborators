module "hmpps-vcms" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms"
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
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"                                                                      #  The name of the person behind github_user
      email        = "simon.creasy@civica.co.uk"                                                         #  Their email address
      org          = "Civica"                                                                            #  The organisation/entity they belong to
      reason       = "Civica developer that helps the development of the Victims Case Management System" #  Why is this person being granted access?
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"          #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-05-21"                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "miriamgo-civica"
      permission   = "maintain"
      name         = "Miriam Gomez-Orozco"                                                          #  The name of the person behind github_user
      email        = "Miriam.Gomez-Orozco@civica.co.uk"                                             #  Their email address
      org          = "Civica"                                                                       #  The organisation/entity they belong to
      reason       = "Civica developer for Victims Case Management System"                          #  Why is this person being granted access?
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2023-02-27"                                                                   #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
