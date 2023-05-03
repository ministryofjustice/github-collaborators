module "deployment-psn-access" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-psn-access"
  collaborators = [
  ]
}
