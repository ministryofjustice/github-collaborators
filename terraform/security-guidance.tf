module "security-guidance" {
  source     = "./modules/repository-collaborators"
  repository = "security-guidance"
  collaborators = [
    {
      github_user  = "L-Crosby"
      permission   = "pull"
      name         = "Luke Crosby"
      email        = "luke.crosby@digital.justice.gov.uk"
      org          = "UK MoJ Digital and Technology"
      reason       = "Reviewing and approving security policy and guidance content"
      added_by     = "adrian.warman@digital.justice.gov.uk"
      review_after = "2022-01-31"
    },
  ]
}
