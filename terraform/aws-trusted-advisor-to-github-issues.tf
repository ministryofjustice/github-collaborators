module "aws-trusted-advisor-to-github-issues" {
  source     = "./modules/repository-collaborators"
  repository = "aws-trusted-advisor-to-github-issues"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
    {
      github_user  = "fkjgnreiuthwoign32342r2r"
      permission   = "admin"
      name         = "nick"
      email        = "nick@home.com"
      org          = "nick Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
  ]
}
