module "yjsm-hub" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-hub"
  collaborators = {
    gregi2n          = "admin"
    griffinjuknps    = "admin"
    AndrewRichards72 = "admin"
  }
}
