module "hmpps-integration-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-integration-api"
  collaborators = [
    {
      github_user  = "chiaramapellimt"
      permission   = "push"
      name         = "Chiara Mapelli"
      email        = "chiara.mapelli@madetech.com"
      org          = "MOJ"
      reason       = "As part of the SIS Team working on the HMPPS API"
      added_by     = "sarah.fernandes@digital.justice.gov.uk"
      review_after = "2024-10-31"
    },
  ]
}
