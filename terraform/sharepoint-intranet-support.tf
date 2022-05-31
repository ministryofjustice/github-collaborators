module "sharepoint-intranet-support" {
  source     = "./modules/repository-collaborators"
  repository = "sharepoint-intranet-support"
  collaborators = [
    {
      github_user  = "dkardokas"
      permission   = "push"
      name         = "Dominykas Kardokas"                         #  The name of the person behind github_user
      email        = "Dominykas.Kardokas@justice.gov.uk"          #  Their email address
      org          = "Triad Group PLC"                            #  The organisation/entity they belong to
      reason       = "Development of custom sharepoint workflows and configuration"         #  Why is this person being granted access?
      added_by     = "Ian Anderson <ian.anderson@digital.justice.gov.uk>"        #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-10-31"                                 #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
