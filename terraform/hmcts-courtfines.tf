module "hmcts-courtfines" {
  source     = "./modules/repository-collaborators"
  repository = "hmcts-courtfines"
  collaborators = [
    {
      github_user  = "jrichards93-hmcts"
      permission   = "push"
      name         = "Jacob Richards"
      email        = "jacob.richards@hmcts.net"
      org          = "CGI"
      reason       = "Support of service"
      added_by     = "david.pearce@Justice.gov.uk"
      review_after = "2025-04-10"
     },
  ]
}
