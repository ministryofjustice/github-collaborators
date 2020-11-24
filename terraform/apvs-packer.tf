module "apvs-packer" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-packer"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
