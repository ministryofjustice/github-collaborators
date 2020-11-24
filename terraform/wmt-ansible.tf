module "wmt-ansible" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-ansible"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
