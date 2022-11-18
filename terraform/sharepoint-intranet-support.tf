module "sharepoint-intranet-support" {
  source     = "./modules/repository-collaborators"
  repository = "sharepoint-intranet-support"
  collaborators = [
    {
      github_user  = "dkardokas"
      permission   = "push"
      name         = "Dominykas Kardokas"                                          
      email        = "Dominykas.Kardokas@justice.gov.uk"                           
      org          = "Triad Group PLC"                                             
      reason       = "Development of custom sharepoint workflows and configuration"
      added_by     = "Ian Anderson <ian.anderson@digital.justice.gov.uk>"          
      review_after = "2022-10-31"                                                  
    },
  ]
}
