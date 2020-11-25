module "apvs-ansible" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-ansible"
  collaborators = {
    Nathanials = "admin"
    kevinfox1  = "admin"
  }
}
