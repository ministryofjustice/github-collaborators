module "c100-application-deploy" {
  source     = "./modules/repository-collaborators"
  repository = "c100-application-deploy"
  collaborators = [
    {
      github_user  = "timja"
      permission   = "push"
      name         = "Tim Jacomb"
      email        = "tim.jacomb@hmcts.net"
      org          = "HMCTS"
      reason       = "HMCTS migration team"
      added_by     = "jake.mulley@digital.justice.gov.uk"
      review_after = "2023-06-29"
    },
  ]
}
