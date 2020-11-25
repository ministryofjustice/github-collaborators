module "securityanalytics-simple-ecs" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-simple-ecs"
  collaborators = {
    blackmamo    = "push"
    progers-tech = "push"
  }
}
