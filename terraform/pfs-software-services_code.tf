module "pfs-software-services_code" {
  source     = "./modules/repository-collaborators"
  repository = "pfs-software-services_code"
  collaborators = [
    {
      github_user  = "nathanials"
      permission   = "admin"
      name         = "Nathanials Stewart"                          #  The name of the person behind github_user
      email        = "n.stewart@kainos.com"                        #  Their email address
      org          = "Kainos"                                      #  The organisation/entity they belong to
      reason       = "Kainos is working on transfering code from a kainos owned repo to an MOJ owned repo" #  Why is this person being granted access?
      added_by     = "Incell Infrastructure team, federico.staiano1@justice.gov.uk"   #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"      #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
