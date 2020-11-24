module "opg-digideps" {
  source     = "./modules/repository-collaborators"
  repository = "opg-digideps"
  collaborators = {
    opg-integrations = "push"
  }
}
