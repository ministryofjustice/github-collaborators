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
    {
      github_user  = "nick"
      permission   = "admin"
      name         = "nick walters"
      email        = "nick.walter@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "nick ben.ashton@digital.justice.gov.uk"
      review_after = "2023-10-10"
    },
  ]
}
