module "yjaf-nginx-gateway" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-nginx-gateway"
  collaborators = {
    gregi2n = "admin"
  }
}
