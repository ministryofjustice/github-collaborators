module "hmpps-digital-prison-reporting-data-product-definitions-schema" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-digital-prison-reporting-data-product-definitions-schema"
  collaborators = [
    {
      github_user  = "djcostin"
      permission   = "push"
      name         = "Daniel Costin"
      email        = "daniel.costin@digital.justice.gov.uk"
      org          = "Modular Data"
      reason       = "Onboarding of new full stack developer, needs access for day to day work."
      added_by     = "mark.mckeown@digital.justice.gov.uk"
      review_after = "2025-03-31"
    },
  ]
}
