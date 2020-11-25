module "yjaf-workflow" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-workflow"
  collaborators = {
    gregi2n              = "admin"
    griffinjuknps        = "push"
    TomDover-NorthgatePS = "push"
  }
}
