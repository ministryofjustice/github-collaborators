module "sentinel" {
  source     = "./modules/repository-collaborators"
  repository = "sentinel"
  collaborators = [
    {
      github_user  = "tephdevokolot-civica"
      permission   = "maintain"
      name         = "Tephraste Devokolot"
      email        = "Tephraste.Devokolot@civica.co.uk"
      org          = "Civica"
      reason       = "Tephraste is a Civica developers working on development of the Victims Case Management System"
      added_by     = "deepee.mann-basra@digital.justice.gov.uk / Nigel.Battson@justice.gov.uk"
      review_after = "2025-02-13"
    },
  ]
}
