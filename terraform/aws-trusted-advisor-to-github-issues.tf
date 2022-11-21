module "aws-trusted-advisor-to-github-issues" {
  source     = "./modules/repository-collaborators"
  repository = "aws-trusted-advisor-to-github-issues"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-19"
    },
  ]
}
