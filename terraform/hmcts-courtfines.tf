module "hmcts-courtfines" {
  source     = "./modules/repository-collaborators"
  repository = "hmcts-courtfines"
  collaborators = [
    {
      github_user  = "jrichards93-hmcts"
      permission   = "admin"
      name         = "Jacob Richards"
      email        = "jacob.richards@hmcts.net"
      org          = "CGI"
      reason       = "Support of service"
      added_by     = "david.pearce@justice.gov.uk"
      review_after = "2025-08-30"
    },
    {
      github_user  = "Dylan-365"
      permission   = "admin"
      name         = "Dylan Horman"
      email        = "Dylan.horman@hmcts.net"
      org          = "CGI"
      reason       = "Support of service"
      added_by     = "david.pearce@justice.gov.uk"
      review_after = "2025-08-30"
    },
    {
      github_user  = "alexdavies2463"
      permission   = "admin"
      name         = "Alex Davies"
      email        = "alex.davies@hmcts.net"
      org          = "CGI"
      reason       = "Support of service"
      added_by     = "david.pearce@justice.gov.uk"
      review_after = "2025-08-30"
    },
    {
      github_user  = "PankajParmar1"
      permission   = "admin"
      name         = "Pankaj Parmar"
      email        = "pankaj.parmar1@hmcts.net"
      org          = "CGI"
      reason       = "Support of service"
      added_by     = "david.pearce@justice.gov.uk"
      review_after = "2025-08-30"
    },
    },
    {
      github_user  = "zachealy113"
      permission   = "admin"
      name         = "Zac Healy"
      email        = "zac.healy@CGI.com"
      org          = "CGI"
      reason       = "Support of service"
      added_by     = "david.pearce@justice.gov.uk"
      review_after = "2025-08-30"
    },
  ]
}
