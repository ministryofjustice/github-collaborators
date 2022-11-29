module "moj-pttp-devicesandapps-pipeline-windows10apps" {
  source     = "./modules/repository-collaborators"
  repository = "moj-pttp-devicesandapps-pipeline-windows10apps"
  collaborators = [
    {
      github_user  = "jimgregory-cplusc"
      permission   = "admin"
      name         = "Jim Gregory"
      email        = "jim.gregory@contentandcloud.com"
      org          = "Content and Cloud"
      reason       = "PTTP Tech team"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2022-12-31"
    },
  ]
}
