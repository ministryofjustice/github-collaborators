module "ProbationHub" {
  source     = "./modules/repository-collaborators"
  repository = "ProbationHub"
  collaborators = {
    antonybakergov = "push"
  }
}
