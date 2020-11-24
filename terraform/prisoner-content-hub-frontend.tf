module "prisoner-content-hub-frontend" {
  source     = "./modules/repository-collaborators"
  repository = "prisoner-content-hub-frontend"
  collaborators = {
    moj-pfs-ci = "push"
  }
}
