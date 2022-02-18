module "bichard7-next-data" {
  source     = "./modules/repository-collaborators"
  repository = "bichard7-next-data"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "Ben Pirt"                                 #  The name of the person behind github_user
      email        = "ben@madetech.com"                         #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "sioldham"
      permission   = "push"
      name         = "Simon Oldham"                             #  The name of the person behind github_user
      email        = "simon.oldham@madetech.com"                #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "emadkaramad"
      permission   = "push"
      name         = "Emad Karamad"                             #  The name of the person behind github_user
      email        = "emad.karamad@madetech.com"                #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "daviesjamie"
      permission   = "push"
      name         = "Jamie Davies"                             #  The name of the person behind github_user
      email        = "jamie.davies@madetech.com"                #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "MihaiMadeT"
      permission   = "push"
      name         = "Mihai-Alexandru Popa-Matei"               #  The name of the person behind github_user
      email        = "mihai.popa-matai@madetech.com"            #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "monotypical"
      permission   = "push"
      name         = "Alice Lee"                                #  The name of the person behind github_user
      email        = "alice.lee@madetech.com"                   #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
    {
      github_user  = "jaskaransarkaria"
      permission   = "push"
      name         = "Jazz Sarkaria"                            #  The name of the person behind github_user
      email        = "jazz.sarkaria@madetech.com"               #  Their email address
      org          = "Madetech"                                 #  The organisation/entity they belong to
      reason       = "CJSE Bichard Development"                 #  Why is this person being granted access?
      added_by     = "Dom Tomkins <dom.tomkins@justice.gov.uk>" #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = "2022-12-31"                               #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    }
  ]
}
