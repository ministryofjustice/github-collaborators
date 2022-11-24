module "network-access-control-admin" {
  source     = "./modules/repository-collaborators"
  repository = "network-access-control-admin"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2023-05-24"
    },
  ]
}
