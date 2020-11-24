module "staff-device-logging-syslog-to-cloudwatch" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-logging-syslog-to-cloudwatch"
  collaborators = {
    neilkidd = "admin"
    jbevan4 = "admin"
  }
}
