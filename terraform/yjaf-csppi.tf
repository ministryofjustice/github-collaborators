module "yjaf-csppi" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-csppi"
  collaborators = {
    gregi2n = "admin"
  }
}
