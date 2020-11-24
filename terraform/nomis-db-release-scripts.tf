module "nomis-db-release-scripts" {
  source     = "./modules/repository-collaborators"
  repository = "nomis-db-release-scripts"
  collaborators = {
    vprabhu001 = "push"
  }
}
