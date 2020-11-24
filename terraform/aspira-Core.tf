module "aspira-Core" {
  source     = "./modules/repository-collaborators"
  repository = "aspira.Core"
  collaborators = {
    antonybakergov = "push"
  }
}
