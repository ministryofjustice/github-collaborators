module "yjaf-nginx-pentaho" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-nginx-pentaho"
  collaborators = {
    gregi2n = "admin"
  }
}
