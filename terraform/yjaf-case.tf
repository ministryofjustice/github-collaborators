module "yjaf-case" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-case"
  collaborators = {
    gregi2n = "admin"
    TomDover-NorthgatePS = "push"
  }
}
