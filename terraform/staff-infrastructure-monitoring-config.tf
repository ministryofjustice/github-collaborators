module "staff-infrastructure-monitoring-config" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-config"
  collaborators = [
    {
      github_user  = "richrace"
      permission   = "admin"
      name         = "Richard Race"
      email        = "richard.race@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@digital.justice.gov.uk"
      review_after = "2021-10-31"
    },
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "MoJ NAC Tech Team"
      added_by     = "justin.fielding@justice.gov.uk"
      review_after = "2022-01-01"
    },
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
    }
  ]
}
