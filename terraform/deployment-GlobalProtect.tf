module "deployment-GlobalProtect" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-GlobalProtect"
  collaborators = [
    {
      github_user  = "nmatveev"
      permission   = "push"
      name         = "Nikolay Matveev"                
      email        = "nmatveev@paloaltonetworks.com"  
      org          = "Palo Alto"                      
      reason       = "PTTP Palo Alto network engineer"
      added_by     = "richard.baguley@justice.gov.uk" 
      review_after = "2022-06-18"                     
    },
  ]
}
