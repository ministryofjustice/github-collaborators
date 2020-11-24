module "fb-housing-disrepair-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "fb-housing-disrepair-prototype"
  collaborators = {
    simcast = "push"
  }
}
