module "itpolicycontent" {
  source     = "./modules/repository-collaborators"
  repository = "itpolicycontent"
  collaborators = {
    tomdMOJ = "push"
  }
}
