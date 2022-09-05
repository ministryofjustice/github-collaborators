module "staff-device-management-virtualdesktop" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-virtualdesktop"
  collaborators = [
    {
      github_user  = "VinceThompson"
      permission   = "push"
      name         = "Vince Thompson"                #  The name of the person behind github_user
      email        = "vthompson@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"             #  The organisation/entity they belong to
      reason       = "PTTP Tech Team"                #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                    #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "BenSnapeCC"
      permission   = "push"
      name         = "Ben Snape"                     #  The name of the person behind github_user
      email        = "ben.snape@contentandcloud.com" #  Their email address
      org          = "Content and Cloud"             #  The organisation/entity they belong to
      reason       = "PTTP Tech Team"                #  Why is this person being granted access?
      added_by     = "matthew.white1@justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                    #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
