module "opg-data-lpa" {
  source     = "./modules/repository-collaborators"
  repository = "opg-data-lpa"
  collaborators = {
    opg-integrations = "push"
  }
}
