module "MojHub" {
  source     = "./modules/repository-collaborators"
  repository = "MojHub"
  collaborators = {
    antonybakergov = "push"
  }
}
