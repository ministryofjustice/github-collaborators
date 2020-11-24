module "staff" {
  source     = "./modules/repository-collaborators"
  repository = "staff"
  collaborators = {
    nickvholbrook = "push"
  }
}
