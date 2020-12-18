module "pttp-shared-services-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "pttp-shared-services-infrastructure"
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
    {
      github_user  = "elena-vi"
      permission   = "admin"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "chubberlisk"
      permission   = "admin"
      name         = "" #  The name of the person behind github_user
      email        = "" #  Their email address
      org          = "" #  The organisation/entity they belong to
      reason       = "" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
