module "yjaf-csppi" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-csppi"
  collaborators = [
    {
      github_user  = "codebysachin"
      permission   = "push"
      name         = "Sachin Gupta"
      email        = "sachin.gupta@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-05-29"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "andrew.richards1@necsws.com"
      org          = "NEC SWS"
      reason       = "Existing developer"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-03-01"
    },
  ]
}
