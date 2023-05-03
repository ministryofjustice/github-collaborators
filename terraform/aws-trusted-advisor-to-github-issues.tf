module "aws-trusted-advisor-to-github-issues" {
  source     = "./modules/repository-collaborators"
  repository = "aws-trusted-advisor-to-github-issues"
  collaborators = [
  ]
}
