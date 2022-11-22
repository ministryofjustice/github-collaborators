module "hmpps-vcms-infra-versions" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms-infra-versions"
  collaborators = [
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation WebOps team, probation-webops@digital.justice.gov.uk"
      review_after = "2022-11-21"
    },
  ]
}
