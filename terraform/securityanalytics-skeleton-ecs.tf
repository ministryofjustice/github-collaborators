module "securityanalytics-skeleton-ecs" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-skeleton-ecs"
  collaborators = {
    blackmamo    = "push"
    progers-tech = "push"
  }
}
