module "opg-use-an-lpa" {
  source     = "./modules/repository-collaborators"
  repository = "opg-use-an-lpa"
  collaborators = [
    {
      github_user  = "weblate"
      permission   = "push"
      name         = "Weblate Push User"
      email        = "hosted@weblate.org"
      org          = "Ministry of Justice"
      reason       = "Used by Weblate"
      added_by     = "adam.cooper@digital.justice.gov.uk"
      review_after = "2025-04-08"
    },
  ]
}
