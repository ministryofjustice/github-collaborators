module "prisoner-content-hub" {
  source     = "./modules/repository-collaborators"
  repository = "prisoner-content-hub"
  collaborators = {
    moj-pfs-ci = "push"
  }
}
