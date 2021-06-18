module "terraform-panorama-config" {
  source     = "./modules/repository-collaborators"
  repository = "terraform-panorama-config"
  collaborators = [
    {
      github_user  = "nmatveev"
      permission   = "push"
      name         = "Nikolay Matveev"                        #  The name of the person behind github_user
      email        = "nmatveev@paloaltonetworks.com"          #  Their email address
      org          = "Palo Alto"                              #  The organisation/entity they belong to
      reason       = "TechOps Management of Panorama"         #  Why is this person being granted access?
      added_by     = "MoJ-TechnicalOperations@justice.gov.uk" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-03-31"                             #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
  ]
}
