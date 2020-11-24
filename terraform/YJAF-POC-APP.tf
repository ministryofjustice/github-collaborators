module "YJAF-POC-APP" {
  source     = "./modules/repository-collaborators"
  repository = "YJAF-POC-APP"
  collaborators = {
    gregi2n = "admin"
  }
}
