module "staff-device-management-windows10-apps" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-windows10-apps"
  collaborators = [
    {
      github_user  = "jazjax"
      permission   = "admin"
      name         = "Jasper Jackson"
      email        = "jasper.jackson@madetech.com"
      org          = "MadeTech"
      reason       = "VICTOR product development"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2023-03-30"
    },
    {
      github_user  = "bingliumt"
      permission   = "admin"
      name         = "Bingjie Liu"
      email        = "bingjie.liu@madetech.com"
      org          = "MadeTech"
      reason       = "VICTOR product development"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2023-09-26"
    },
  ]
}
