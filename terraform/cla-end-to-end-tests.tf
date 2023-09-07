module "cla-end-to-end-tests" {
  source     = "./modules/repository-collaborators"
  repository = "cla-end-to-end-tests"
  collaborators = [
    {
      github_user  = "benmillar-cgi"
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
