module "yjaf-poc-app" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-poc-app"
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
  ]
}
