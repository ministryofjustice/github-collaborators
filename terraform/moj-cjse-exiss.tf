module "moj-cjse-exiss" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-exiss"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "Ben Pirt"                                 #  The name of the person behind github_user
      email        = "ben@madetech.com"                         #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2021-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "midlabcrisis"
      permission   = "push"
      name         = "Adam Taylor"
      email        = "adam.taylor@digital.justice.gov.uk"
      org          = "MoJ"
      reason       = "CJSE Development"
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2021-12-31"
    },
    {
      github_user  = "graysok"
      permission   = "push"
      name         = "Kevin Hoskins"
      email        = "kevin.hoskins@q-solution.co.uk"
      org          = "Q Solution"
      reason       = "CJSE Development"
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2021-12-31"
    },
    {
      github_user  = "flaxington"
      permission   = "push"
      name         = "Lee Flaxington"
      email        = "lee.flaxington@q-solution.co.uk"
      org          = "Q Solution"
      reason       = "CJSE Development"
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>"
      review_after = "2021-12-31"
    }
  ]
}
