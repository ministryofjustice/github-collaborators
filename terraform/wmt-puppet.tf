module "wmt-puppet" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-puppet"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
