module "staff-infrastructure-monitoring-config" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-config"
  collaborators = [
    {
      github_user  = "yusufsheiqh"
      permission   = "admin"
      name         = "Yusuf Sheikh"
      email        = "yusuf@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ NAC Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
  ]
}
