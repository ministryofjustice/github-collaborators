module "delius" {
  source     = "./modules/repository-collaborators"
  repository = "delius"
  collaborators = [
    {
      github_user  = "johngriffin"
      permission   = "pull"
      name         = "John Griffin"                                                                                    
      email        = "john.griffin@digital.justice.gov.uk"                                                             
      org          = "Create Change"                                                                                   
      reason       = "AI Architect working on Making Recall Decisions"                                                 
      added_by     = "Duncan Crawford on behalf of Making Recall Decision team, Duncan.Crawford@digital.justice.gov.uk"
      review_after = "2021-12-31"                                                                                      
    },
  ]
}
