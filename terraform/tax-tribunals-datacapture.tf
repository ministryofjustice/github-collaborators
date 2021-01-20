module "tax-tribunals-datacapture" {
  source     = "./modules/repository-collaborators"
  repository = "tax-tribunals-datacapture"
  collaborators = [
    {
      github_user  = "jriga"
      permission   = "maintain"
      name         = "Jerome Riga" #  The name of the person behind github_user
      email        = "jerome.riga@hmcts.net" #  Their email address
      org          = "HMCTS" #  The organisation/entity they belong to
      reason       = "Project maintainer" #  Why is this person being granted access?
      added_by     = "Sunil.Parmar@HMCTS.NET" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-06-01" #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
