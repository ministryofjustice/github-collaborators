module "laa-ccr-db-scripts" {
  source     = "./modules/repository-collaborators"
  repository = "laa-ccr-db-scripts"
  collaborators = {
    abelsky = "push"
    annaep  = "push"
  }
}
