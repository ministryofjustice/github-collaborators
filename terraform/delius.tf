module "delius" {
  source     = "./modules/repository-collaborators"
  repository = "delius"
  collaborators = [
    {
      github_user  = "johngriffin"
      permission   = "pull"
      name         = "John Griffin"                                                                                     #  The name of the person behind github_user
      email        = "john.griffin@digital.justice.gov.uk"                                                              #  Their email address
      org          = "Create Change"                                                                                    #  The organisation/entity they belong to
      reason       = "AI Architect working on Making Recall Decisions"                                                  #  Why is this person being granted access?
      added_by     = "Duncan Crawford on behalf of Making Recall Decision team, Duncan.Crawford@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                                                                       #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
