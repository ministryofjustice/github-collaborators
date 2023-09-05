module "cla_public" {
  source     = "./modules/repository-collaborators"
  repository = "cla_public"
  collaborators = [
    {
      github_user  = "BenMillar-CGI "
      permission   = "push"
      name         = "Ben Millar"
      email        = "ben.millar@digital.justice.gov.uk"
      org          = "CGI"
      reason       = "needs to be able to submit and approve pull requests, push access to CLA repositories"
      added_by     = "heather.poole@digital.justice.gov.uk"
      review_after = "2024-03-05"
    },
  ]
}
