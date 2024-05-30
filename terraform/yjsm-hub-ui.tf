module "yjsm-hub-ui" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-hub-ui"
  collaborators = [
    {
      github_user  = "codebysachin"
      permission   = "push"
      name         = "Sachin Gupta"
      email        = "sachin.gupta@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "sam.pepper@digital.justice.gov.uk"
      review_after = "2025-05-29"
    },
  ]
}
