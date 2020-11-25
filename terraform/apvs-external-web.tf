module "apvs-external-web" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-external-web"
  collaborators = {
    Nathanials = "admin"
    kevinfox1  = "admin"
  }
}
