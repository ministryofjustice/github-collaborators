module "laa-infoX-application" {
  source     = "./modules/repository-collaborators"
  repository = "laa-infoX-application"
  collaborators = {
    abelsky = "push"
  }
}
