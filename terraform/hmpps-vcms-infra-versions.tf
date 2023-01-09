module "hmpps-vcms-infra-versions" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms-infra-versions"
  collaborators = [
    {
      github_user  = "nick"
      permission   = "maintain"
      name         = "nick walters"
      email        = "nick.walters@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "nick"
      review_after = "2023-10-10"
    },
  ]
}
