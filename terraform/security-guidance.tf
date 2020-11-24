module "security-guidance" {
  source     = "./modules/repository-collaborators"
  repository = "security-guidance"
  collaborators = {
    tomdMOJ = "push"
  }
}
