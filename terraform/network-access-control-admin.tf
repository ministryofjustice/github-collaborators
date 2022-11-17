module "network-access-control-admin" {
  source     = "./modules/repository-collaborators"
  repository = "network-access-control-admin"
  collaborators = [
    {
      github_user  = "yusufsheiqh"
      permission   = "admin"
      name         = "Yusuf Sheikh"
      email        = "yusuf@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
  ]
}
