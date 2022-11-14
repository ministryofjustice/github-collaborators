module "network-access-control-disaster-recovery" {
  source     = "./modules/repository-collaborators"
  repository = "network-access-control-disaster-recovery"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-08-28"
    },
    {
      github_user  = "yusufsheiqh"
      permission   = "admin"
      name         = "Yusuf Sheikh"
      email        = "yusuf@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-08-28"
    },
    {
      github_user  = "MichaelCullenMadeTech"
      permission   = "admin"
      name         = "Michael Cullen"
      email        = "michael.cullen@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-08-28"
    },
    {
      github_user  = "C-gyorfi"
      permission   = "admin"
      name         = "Csaba Gyorfi"
      email        = "csaba@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ Network Access Control Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-08-28"
    },
  ]
}
