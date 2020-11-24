module "pattern-library" {
  source     = "./modules/repository-collaborators"
  repository = "pattern-library"
  collaborators = {
    timpaul = "push"
    Granitehead = "admin"
  }
}
