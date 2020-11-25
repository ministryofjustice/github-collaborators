module "apvs-asynchronous-worker" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-asynchronous-worker"
  collaborators = {
    Nathanials = "admin"
    kevinfox1  = "admin"
  }
}
