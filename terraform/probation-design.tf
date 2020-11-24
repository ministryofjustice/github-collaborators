module "probation-design" {
  source     = "./modules/repository-collaborators"
  repository = "probation-design"
  collaborators = {
    Granitehead = "push"
  }
}
