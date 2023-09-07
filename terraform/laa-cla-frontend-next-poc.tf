module "laa-cla-frontend-next-poc" {
  source     = "./modules/repository-collaborators"
  repository = "laa-cla-frontend-next-poc"
  collaborators = [
    {
      github_user  = "benmillar-cgi"
      permission   = "admin"
      name         = "ben millar"
      email        = "ben.millar@digital.justice.gov.uk"
      org          = "cgi"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-06"
    },
  ]
}
