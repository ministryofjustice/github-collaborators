module "wmt-data-migration" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-data-migration"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
