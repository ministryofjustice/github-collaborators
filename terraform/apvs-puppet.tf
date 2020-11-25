module "apvs-puppet" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-puppet"
  collaborators = {
    Nathanials = "admin"
    kevinfox1  = "admin"
  }
}
