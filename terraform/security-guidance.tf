module "security-guidance" {
  source     = "./modules/repository-collaborators"
  repository = "security-guidance"
  collaborators = [
    {
      github_user  = "tomdMOJ"
      permission   = "push"
      name         = "Tom Dumic"
      email        = "tom.dumic@digital.justice.gov.uk"
      org          = "UK MoJ Digital and Technology"
      reason       = "Writing security policy and guidance content"
      added_by     = "adrian.warman@digital.justice.gov.uk"
      review_after = "2022-01-31"
    },
  ]
}
