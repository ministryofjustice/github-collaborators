module "ndelius-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "ndelius-prototype"
  collaborators = {
    Granitehead = "push"
  }
}
