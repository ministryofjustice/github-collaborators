module "staff-infrastructure-monitoring-config" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-config"
  collaborators = [
    {
      github_user  = "C-gyorfi"
      permission   = "admin"
      name         = "Csaba Gyorfi"
      email        = "csaba@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ NAC Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
    {
      github_user  = "MichaelCullenMadeTech"
      permission   = "admin"
      name         = "Michael Cullen"
      email        = "michael.cullen@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ NAC Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
  ]
}
