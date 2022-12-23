module "some-repo" {
  source        = "./modules/repository-collaborators"
  repository    = "some.repo"
  collaborators = []
}
