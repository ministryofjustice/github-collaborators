module "operations-engineering" {
  source     = "./modules/repository-collaborators"
  repository = "operations-engineering"
  collaborators = {
    DangerDawson = "push"
  }
}
