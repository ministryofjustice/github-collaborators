module "recalldecision-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "recalldecision-prototype"
  collaborators = [
    {
      github_user  = "happygeneralist"
      permission   = "pull"
      name         = "Ryan Haney"                                                                                       #  The name of the person behind github_user
      email        = "ryan.haney@digital.justice.gov.uk"                                                                #  Their email address
      org          = "Create Change"                                                                                    #  The organisation/entity they belong to
      reason       = "UX designer working on Making Recall Decisions"                                                   #  Why is this person being granted access?
      added_by     = "Duncan Crawford on behalf of Making Recall Decision team, Duncan.Crawford@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                                                                       #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "RebeccaCryan"
      permission   = "pull"
      name         = "Rebecca Cryan"                                                                                       #  The name of the person behind github_user
      email        = "rebecca.cryan@digital.justice.gov.uk"                                                                #  Their email address
      org          = "Create Change"                                                                                    #  The organisation/entity they belong to
      reason       = "Content designer working on Making Recall Decisions"                                                   #  Why is this person being granted access?
      added_by     = "Duncan Crawford on behalf of Making Recall Decision team, Duncan.Crawford@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                                                                       #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
