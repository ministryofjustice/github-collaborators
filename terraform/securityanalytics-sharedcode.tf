module "securityanalytics-sharedcode" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-sharedcode"
  collaborators = {
    blackmamo = "admin"
    progers-tech = "admin"
  }
}
