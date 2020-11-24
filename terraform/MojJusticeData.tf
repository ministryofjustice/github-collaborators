module "MojJusticeData" {
  source     = "./modules/repository-collaborators"
  repository = "MojJusticeData"
  collaborators = {
    antonybakergov = "push"
  }
}
