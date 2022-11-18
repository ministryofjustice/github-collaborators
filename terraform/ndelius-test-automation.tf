module "ndelius-test-automation" {
  source     = "./modules/repository-collaborators"
  repository = "ndelius-test-automation"
  collaborators = [
    {
      github_user  = "mlaskowski4"
      permission   = "admin"
      name         = "Michal Laskowski"                                                                 
      email        = "mlaskowski@unilink.com"                                                           
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
    {
      github_user  = "peter-bcl"
      permission   = "admin"
      name         = "Peter Wilson"                                                                     
      email        = "pwilson@unilink.com"                                                              
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
    {
      github_user  = "unilinkuser-alexo"
      permission   = "admin"
      name         = "Alex Oyedele"                                                                     
      email        = "aoyedele@unilink.com"                                                             
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
    {
      github_user  = "ND070322"
      permission   = "admin"
      name         = "Neale Davison"                                                                    
      email        = "ndavison@unilink.com"                                                             
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
    {
      github_user  = "jrobson-unilink"
      permission   = "admin"
      name         = "James Robson"                                                                     
      email        = "jrobson@unilink.com"                                                              
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
    {
      github_user  = "yfedkiv"
      permission   = "admin"
      name         = "Yuri Fedkiv"                                                                      
      email        = "yfedviv@unilink.com"                                                              
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
    {
      github_user  = "linda182"
      permission   = "admin"
      name         = "Linda Clarke"                                                                     
      email        = "lclarke@unilink.com"                                                              
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-02-25"                                                                       
    },
  ]
}
