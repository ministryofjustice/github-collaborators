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
  ]
}
