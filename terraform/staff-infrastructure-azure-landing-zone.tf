module "staff-infrastructure-azure-landing-zone" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-azure-landing-zone"
  collaborators = [
    {
      github_user  = "bsharpen-soltec"
      permission   = "push"
      name         = "Barry Sharpen"                              #  The name of the person behind github_user
      email        = "bsharpen@sol-tec.com"                       #  Their email address
      org          = "Sol-Tec"                                    #  The organisation/entity they belong to
      reason       = "PTTP Tech team building Azure Landing Zone" #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                 #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "cscales-soltec"
      permission   = "push"
      name         = "Chris Scales"                               #  The name of the person behind github_user
      email        = "cscales@sol-tec.com"                        #  Their email address
      org          = "Sol-Tec"                                    #  The organisation/entity they belong to
      reason       = "PTTP Tech team building Azure Landing Zone" #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                 #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "RyanLWilliams"
      permission   = "push"
      name         = "Ryan Williams"                              #  The name of the person behind github_user
      email        = "rwilliams@sol-tec.com"                      #  Their email address
      org          = "Sol-Tec"                                    #  The organisation/entity they belong to
      reason       = "PTTP Tech team building Azure Landing Zone" #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                 #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "jabenny"
      permission   = "push"
      name         = "Josh Benfield"                              #  The name of the person behind github_user
      email        = "jbenfield@sol-tec.com"                      #  Their email address
      org          = "Sol-Tec"                                    #  The organisation/entity they belong to
      reason       = "PTTP Tech team building Azure Landing Zone" #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk"              #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                                 #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
