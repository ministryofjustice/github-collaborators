module "staff-infrastructure-monitoring" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring"
  collaborators = {
    thip = "push"
    elena-vi = "push"
    chubberlisk = "push"
    jbevan4 = "push"
  }
}
