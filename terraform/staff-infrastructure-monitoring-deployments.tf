module "staff-infrastructure-monitoring-deployments" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-deployments"
  collaborators = [
    {
      github_user  = "thip"
      permission   = "admin"
      name         = "David Capper"
      email        = "david.capper@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "Themitchell"
      permission   = "admin"
      name         = "Andy Mitchell"
      email        = "andrew.mitchell@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@justice.gov.uk"
      review_after = "2021-06-01"
    },
  ]
}