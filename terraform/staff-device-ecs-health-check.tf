module "staff-device-ecs-health-check" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-ecs-health-check"
  collaborators = {
    jbevan4 = "admin"
  }
}
