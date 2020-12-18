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
      github_user  = "neilkidd"
      permission   = "admin"
      name         = "Neil Kidd"
      email        = "neil.kidd@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "jivdhaliwal"
      permission   = "admin"
      name         = "Jiv Dhaliwal"
      email        = "jiv.dhaliwal@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "CaitBarnard"
      permission   = "admin"
      name         = "Caitlin Barnard"
      email        = "caitlin@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "jbevan4"
      permission   = "admin"
      name         = "Joshua-Luke Bevan"
      email        = "joshua.bevan@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
    {
      github_user  = "efuaakum"
      permission   = "admin"
      name         = "Efua Akumanyi"
      email        = "efua.akumanyi@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "nick.holbrook@justice.gov.uk"
      review_after = "2021-06-01"
    },
  ]
}
