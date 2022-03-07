module "transition" {
  source     = "./modules/repository-collaborators"
  repository = "transition"
  collaborators = [
    {
      github_user  = "InFlamesForever"
      permission   = "admin"
      name         = "Richard Came"
      email        = "richard.came@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "richardbradwell"
      permission   = "admin"
      name         = "Richard Bradwell"
      email        = "richard.bradwell@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
    {
      github_user  = "TomDover-NorthgatePS"
      permission   = "admin"
      name         = "Tom Dover"
      email        = "tom.dover@necsws.com"
      org          = "NEC SWS"
      reason       = "Working on transition project"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-03-07"
    },
  ]
}
