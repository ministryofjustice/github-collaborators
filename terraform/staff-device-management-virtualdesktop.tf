module "staff-device-management-virtualdesktop" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-virtualdesktop"
  collaborators = {
    calkin = "push"
    RyanLWilliams = "push"
    VinceThompson = "push"
  }
}
