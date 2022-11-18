module "delius-releases" {
  source     = "./modules/repository-collaborators"
  repository = "delius-releases"
  collaborators = [
    {
      github_user  = "MichaelWetherallBCL"
      permission   = "admin"
      name         = "Michael Wetherall"                                                                
      email        = "mwetherall@unilink.com"                                                           
      org          = "Unilink"                                                                          
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"                             
      review_after = "2023-09-22"                                                                       
    },
  ]
}
