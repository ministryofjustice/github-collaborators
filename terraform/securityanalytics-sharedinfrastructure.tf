module "securityanalytics-sharedinfrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-sharedinfrastructure"
  collaborators = {
    blackmamo = "admin"
    progers-tech = "admin"
  }
}
