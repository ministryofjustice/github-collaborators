module "staff-infrastructure-monitoring-snmpexporter" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-snmpexporter"
  collaborators = {
    thip        = "push"
    elena-vi    = "push"
    chubberlisk = "push"
  }
}
