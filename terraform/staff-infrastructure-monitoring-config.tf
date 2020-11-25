module "staff-infrastructure-monitoring-config" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-config"
  collaborators = {
    thip        = "push"
    elena-vi    = "push"
    chubberlisk = "push"
    CaitBarnard = "push"
    jbevan4     = "push"
  }
}
