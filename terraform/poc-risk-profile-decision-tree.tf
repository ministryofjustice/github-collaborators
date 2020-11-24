module "poc-risk-profile-decision-tree" {
  source     = "./modules/repository-collaborators"
  repository = "poc-risk-profile-decision-tree"
  collaborators = {
    enricodurs = "push"
  }
}
