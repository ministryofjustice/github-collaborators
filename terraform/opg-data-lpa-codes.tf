module "opg-data-lpa-codes" {
  source     = "./modules/repository-collaborators"
  repository = "opg-data-lpa-codes"
  collaborators = {
    opg-integrations = "push"
  }
}
