module "laa-cla-frontend-next-poc" {
  source     = "./modules/repository-collaborators"
  repository = "laa-cla-frontend-next-poc"
  collaborators = [
    {
      github_user  = "benmillar-cgi"
      permission   = "admin"
      name         = "Ben Millar"
      email        = "ben.millar@digital.justice.gov.uk"
      org          = "CGI"
      reason       = "needs to be able to submit and approve pull requests, push access to CLA repositories"
      added_by     = "heather.poole@digital.justice.gov.uk"
      review_after = "2024-03-05"
    },
  ]
}
