module "github-collaborators" {
  source     = "./modules/repository-collaborators"
  repository = "github-collaborators"
  collaborators = [
    {
      github_user  = "richardcane"
      permission   = "push"
      name         = "Richard Cane"
      email        = "richard.cane@madetech.com"
      org          = "Madetech"
      reason       = "To allow collaborator to raise PRs to manage off-boarding of other collaborators"
      added_by     = "antony.bishop@digital.justice.gov.uk"
      review_after = "2025-06-27"
    },
  ]
}
