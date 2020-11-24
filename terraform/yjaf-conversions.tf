module "yjaf-conversions" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-conversions"
  collaborators = {
    gregi2n = "admin"
    TomDover-NorthgatePS = "push"
  }
}
