module "staff-device-logging-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-logging-infrastructure"
  collaborators = [
    {
      github_user  = "Themitchell"
      permission   = "admin"
      name         = "Andy Mitchell"
      email        = "andrew.mitchell@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "thip"
      permission   = "admin"
      name         = "David Capper"
      email        = "david.capper@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "elcorbs"
      permission   = "admin"
      name         = "Emma Corbett"
      email        = "emma.corbett@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
  ]
}
