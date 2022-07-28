module "c100-application-deploy" {
  source     = "./modules/repository-collaborators"
  repository = "c100-application-deploy"
  collaborators = [
    {
      github_user  = "timja"
      permission   = "push"
      name         = "Tim Jacomb"                         # The name of the person behind github_user
      email        = "tim.jacomb@hmcts.net"               # Their email address
      org          = "HMCTS"                              # The organisation/entity they belong to
      reason       = "HMCTS migration team"               # Why is this person being granted access?
      added_by     = "jake.mulley@digital.justice.gov.uk" # Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                         # Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
