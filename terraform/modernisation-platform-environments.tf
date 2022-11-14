module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "agilisys-agardner"
      permission   = "push"
      name         = "Andrew Gardener"
      email        = "andrew.gardner@agilisys.co.uk"
      org          = "Agilisys"
      reason       = "Get access to data-and-insights-hub on Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-02-23"
    },
  ]
}
