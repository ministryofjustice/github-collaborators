module "moj-cjse-xhibit-portal" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-xhibit-portal"
  collaborators = [
    {
      github_user  = "nickemutch"
      permission   = "pull"
      name         = "Nick Mutch"
      email        = "nick.mutch@q-solution.co.uk"
      org          = "q-solution"
      reason       = "The supplier has been engaged to conduct a technical deep dive and discovery on a future integration"
      added_by     = "dom.tomkins@digital.justice.gov.uk"
      review_after = "2025-03-31"
    },
  ]
}
