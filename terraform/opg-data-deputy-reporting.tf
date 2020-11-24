module "opg-data-deputy-reporting" {
  source     = "./modules/repository-collaborators"
  repository = "opg-data-deputy-reporting"
  collaborators = {
    opg-integrations = "push"
  }
}
