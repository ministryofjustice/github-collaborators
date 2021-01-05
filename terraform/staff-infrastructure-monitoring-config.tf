module "staff-infrastructure-monitoring-config" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-config"
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
      github_user  = "elcorbs"
      permission   = "admin"
      name         = "Emma Corbett"
      email        = "emma@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@justice.gov.uk"
      review_after = "2021-06-01"
    }
  ]
}
