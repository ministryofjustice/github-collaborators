module "wmt-packer" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-packer"
  collaborators = {
    Nathanials = "admin"
    kevinfox1  = "admin"
  }
}
