module "apvs-internal-web" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-internal-web"
  collaborators = {
    Nathanials = "admin"
    kevinfox1  = "admin"
  }
}
