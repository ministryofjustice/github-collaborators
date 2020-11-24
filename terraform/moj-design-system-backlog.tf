module "moj-design-system-backlog" {
  source     = "./modules/repository-collaborators"
  repository = "moj-design-system-backlog"
  collaborators = {
    simcast = "push"
  }
}
