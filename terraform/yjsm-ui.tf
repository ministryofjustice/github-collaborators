module "yjsm-ui" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-ui"
  collaborators = {
    gregi2n = "admin"
    griffinjuknps = "admin"
  }
}
