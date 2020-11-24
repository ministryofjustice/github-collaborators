module "apvs" {
  source     = "./modules/repository-collaborators"
  repository = "apvs"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
