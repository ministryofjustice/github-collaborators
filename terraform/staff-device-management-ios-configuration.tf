module "staff-device-management-ios-configuration" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-ios-configuration"
  collaborators = [
    {
      github_user  = "JazJax"
      permission   = "admin"
      name         = "Jasper Jackson"
      email        = "jasper.jackson@madetech.com"
      org          = "MadeTech"
      reason       = "VICTOR product development"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2022-12-31"
    },
    {
      github_user  = "BingliuMT"
      permission   = "admin"
      name         = "Bingjie Liu"
      email        = "bingjie.liu@madetech.com"
      org          = "MadeTech"
      reason       = "VICTOR product development"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2022-12-31"
    }
  ]
}
