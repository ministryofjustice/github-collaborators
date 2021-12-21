module "transit-gateways" {
  source     = "./modules/repository-collaborators"
  repository = "transit-gateways"
  collaborators = [
    {
      github_user  = "swestb"
      permission   = "push"                                                                                  #  pull|push|admin
      name         = "Stuart Westbrook"                                                                      #  The name of the person behind github_user
      email        = "stuart.westbrook@adrocgroup.com"                                                       #  Their email address
      org          = "adroc group."                                                                          #  The organisation/entity they belong to
      reason       = "To help connect Deluis to its required components in North Bridge via transit gateway" #  Why is this person being granted access?
      added_by     = "Richard.Baguley@digital.justice.gov.uk"                                                #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-02-09"                                                                            #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}