module "dso-infra-azure-ad" {
  source     = "./modules/repository-collaborators"
  repository = "dso-infra-azure-ad"
  collaborators = [
    {
      github_user  = "SimonGivan"
      permission   = "admin"
      name         = "Simon Givan"                                      # The name of the person
      email        = "s.givan@kainos.com"                               # Email
      org          = "Kainos"                                           #  The organisation/entity they belong to
      reason       = "Approved by DSO team to add new users into Azure" #  Why is this person being granted access?
      added_by     = "Jake Mulley <jake.mulley@digital.justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                                       #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
