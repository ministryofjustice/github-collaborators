module "yjaf-transfers" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-transfers"
  collaborators = {
    gregi2n              = "admin"
    griffinjuknps        = "admin"
    TomDover-NorthgatePS = "push"
  }
}
