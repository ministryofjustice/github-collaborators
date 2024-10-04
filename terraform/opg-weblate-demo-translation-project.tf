module "opg-weblate-demo-translation-project" {
  source     = "./modules/repository-collaborators"
  repository = "opg-weblate-demo-translation-project"
  collaborators = [
    {
      github_user  = "weblate"
      permission   = "push"
      name         = "Weblate Push User"
      email        = "hosted@weblate.org"
      org          = "Ministry of Justice"
      reason       = "Used by Weblate"
      added_by     = "andrew.pearce@digital.justice.gov.uk"
      review_after = "2025-04-08"
    },
  ]
}
