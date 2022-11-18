module "bichard7-next" {
  source     = "./modules/repository-collaborators"
  repository = "bichard7-next"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "Ben Pirt"                                
      email        = "ben@madetech.com"                        
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "sioldham"
      permission   = "push"
      name         = "Simon Oldham"                            
      email        = "simon.oldham@madetech.com"               
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "emadkaramad"
      permission   = "push"
      name         = "Emad Karamad"                            
      email        = "emad.karamad@madetech.com"               
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "daviesjamie"
      permission   = "admin"
      name         = "Jamie Davies"                            
      email        = "jamie.davies@madetech.com"               
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "monotypical"
      permission   = "push"
      name         = "Alice Lee"                               
      email        = "alice.lee@madetech.com"                  
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "jaskaransarkaria"
      permission   = "admin"
      name         = "Jazz Sarkaria"                           
      email        = "jazz.sarkaria@madetech.com"              
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "C-gyorfi"
      permission   = "push"
      name         = "Csaba Gyorfi"                            
      email        = "csaba@madetech.com"                      
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "tomvaughan77"
      permission   = "push"
      name         = "Tom Vaughan"                             
      email        = "tom.vaughan@madetech.com"                
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "joe-fol"
      permission   = "push"
      name         = "Joe Folkard"                             
      email        = "joe.folkard@madetech.com"                
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "donnyhyon"
      permission   = "push"
      name         = "Donnie Hyon"                             
      email        = "donny.hyon@madetech.com"                 
      org          = "Madetech"                                
      reason       = "CJSE Bichard Development"                
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "SachinDangui"
      permission   = "pull"
      name         = "Sachin Dangui"                           
      email        = "Sachin.Dangui@hmcts.net"                 
      org          = "HMCTS"                                   
      reason       = "Integration testing for Common Platform" 
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    },
    {
      github_user  = "maheshsubramanian"
      permission   = "pull"
      name         = "Mahesh Subramanian"                      
      email        = "Mahesh.Subramanian1@hmcts.net"           
      org          = "HMCTS"                                   
      reason       = "Integration testing for Common Platform" 
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2022-12-31"                              
    }
  ]
}
