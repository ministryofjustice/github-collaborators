module "staff-device-dns-dhcp-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-dns-dhcp-infrastructure"
  collaborators = [
    {
      github_user  = "Themitchell"
      permission   = "admin"
      name         = "Andy Mitchell" #  The name of the person behind github_user
      email        = "andrew.mitchell@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "thip"
      permission   = "admin"
      name         = "David Capper" #  The name of the person behind github_user
      email        = "david.capper@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "neilkidd"
      permission   = "admin"
      name         = "Neil Kidd" #  The name of the person behind github_user
      email        = "neil.kidd@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "jivdhaliwal"
      permission   = "admin"
      name         = "Jiv Dhaliwal" #  The name of the person behind github_user
      email        = "jiv.dhaliwal@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "CaitBarnard"
      permission   = "admin"
      name         = "Caitlin Barnard" #  The name of the person behind github_user
      email        = "caitlin@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "jbevan4"
      permission   = "admin"
      name         = "Joshua-Luke Bevan" #  The name of the person behind github_user
      email        = "joshua.bevan@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "efuaakum"
      permission   = "admin"
      name         = "Efua Akumanyi" #  The name of the person behind github_user
      email        = "efua.akumanyi@madetech.com" #  Their email address
      org          = "Made Tech Ltd" #  The organisation/entity they belong to
      reason       = "Working on PTTP Security Logging and DNS / DHCP services" #  Why is this person being granted access?
      added_by     = "" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-03-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
