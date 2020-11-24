module "opg-data" {
  source     = "./modules/repository-collaborators"
  repository = "opg-data"
  collaborators = {
    opg-integrations = "push"
  }
}
