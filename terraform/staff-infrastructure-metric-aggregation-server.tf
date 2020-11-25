module "staff-infrastructure-metric-aggregation-server" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-metric-aggregation-server"
  collaborators = {
    thip        = "push"
    elena-vi    = "push"
    chubberlisk = "push"
    jbevan4     = "push"
  }
}
