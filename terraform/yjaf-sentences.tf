module "yjaf-sentences" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-sentences"
  collaborators = {
    gregi2n = "admin"
    TomDover-NorthgatePS = "push"
  }
}
