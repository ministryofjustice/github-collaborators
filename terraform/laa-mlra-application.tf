module "laa-mlra-application" {
  source     = "./modules/repository-collaborators"
  repository = "laa-mlra-application"
  collaborators = {
    abelsky = "push"
  }
}
