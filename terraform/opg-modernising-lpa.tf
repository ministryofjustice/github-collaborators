module "opg-modernising-lpa" {
  source     = "./modules/repository-collaborators"
  repository = "opg-modernising-lpa"
  collaborators = [
    {
      github_user  = "weblate"
      permission   = "push"
      name         = "Weblate Push User"
      email        = "hosted@weblate.org"
      org          = "Ministry of Justice"
      reason       = "Used by Weblate"
      added_by     = "andrew.pearce@digital.justice.gov.uk"
      review_after = "2025-10-10"
    },
  ]
}
