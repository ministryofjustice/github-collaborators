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
      review_after = "2022-01-01"
    },
    {
      github_user  = "MichaelCullenMadeTech"
      permission   = "admin"
      name         = "Michael Cullen"
      email        = "michael.cullen@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
    {
      github_user  = "C-gyorfi"
      permission   = "admin"
      name         = "Csaba Gyorfi"
      email        = "csaba@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
  ]
}
