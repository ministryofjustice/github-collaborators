module "wmt-azurerm" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-azurerm"
  collaborators = {
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
