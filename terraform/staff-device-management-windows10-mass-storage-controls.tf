module "staff-device-management-windows10-mass-storage-controls" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-windows10-mass-storage-controls"
  collaborators = [
    {
      github_user  = "bingliumt"
      permission   = "admin"
      name         = "Bingjie Liu"
      email        = "bingjie.liu@madetech.com"
      org          = "MadeTech"
      reason       = "VICTOR product development"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2023-03-30"
    },
  ]
}
