module "yjaf-app-template" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-app-template"
  collaborators = {
    gregi2n = "admin"
  }
}
