module "securityanalytics-taskexecution" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-taskexecution"
  collaborators = {
    blackmamo    = "admin"
    progers-tech = "admin"
  }
}
