module "laa-aws-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "laa-aws-infrastructure"
  collaborators = {
    shaunfrost-moj = "pull"
  }
}
