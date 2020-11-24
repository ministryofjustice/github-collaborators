module "laa-maat-application" {
  source     = "./modules/repository-collaborators"
  repository = "laa-maat-application"
  collaborators = {
    abelsky = "push"
  }
}
