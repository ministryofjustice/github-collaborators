module "delius" {
  source     = "./modules/repository-collaborators"
  repository = "delius"
  collaborators = [
    {
      github_user  = "duncancrawford"
      permission   = "pull"
      name         = "Duncan Crawford"                                                                                   #  The name of the person behind github_user
      email        = "Duncan.Crawford@digital.justice.gov.uk"                                                            #  Their email address
      org          = "Equal Experts"                                                                                     #  The organisation/entity they belong to
      reason       = "Technical Architect working on Delius"                                                             #  Why is this person being granted access?
      added_by     = "Jake Mulley on behalf of Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                                                                        #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "rjsloane"
      permission   = "pull"
      name         = "Richard Sloane"                                                                                   #  The name of the person behind github_user
      email        = "richard.sloane@digital.justice.gov.uk"                                                            #  Their email address
      org          = "Equal Experts"                                                                                    #  The organisation/entity they belong to
      reason       = "Data Scientist working on Making Recall Decisions"                                                #  Why is this person being granted access?
      added_by     = "Duncan Crawford on behalf of Making Recall Decision team, Duncan.Crawford@digital.justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                                                                       #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
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
  ]
}
