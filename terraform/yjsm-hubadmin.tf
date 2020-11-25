module "yjsm-hubadmin" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-hubadmin"
  collaborators = {
    gregi2n          = "admin"
    griffinjuknps    = "admin"
    AndrewRichards72 = "admin"
  }
}
