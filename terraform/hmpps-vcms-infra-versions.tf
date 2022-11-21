module "hmpps-vcms-infra-versions" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms-infra-versions"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer that helps the development of the Victims Case Management System"
      added_by     = "Probation WebOps team, probation-webops@digital.justice.gov.uk"
      review_after = "2022-11-21"
    },
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation WebOps team, probation-webops@digital.justice.gov.uk"
      review_after = "2023-05-20"
    },
  ]
}
