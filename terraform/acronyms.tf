module "acronyms" {
  source     = "./modules/repository-collaborators"
  repository = "acronyms"
  collaborators = [
    {
      github_user  = "matthewtansini"
      permission   = "push"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "al-ben"
      permission   = "admin"
      name         = "Ben Ashton"         
      email        = "ben.ashton@digital.justice.gov.uk"        
      org          = "Automation Logic"          
      reason       = "Testing this pipeline"       
      added_by     = "Ben Ashton ben.ashton@digital.justice.gov.uk"     
      review_after = "2022-10-10" 
    },
  ]
}
