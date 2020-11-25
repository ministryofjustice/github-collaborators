module "yjaf-returns" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-returns"
  collaborators = {
    gregi2n              = "admin"
    TomDover-NorthgatePS = "push"
  }
}
