module "apvs-azurerm" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-azurerm"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
