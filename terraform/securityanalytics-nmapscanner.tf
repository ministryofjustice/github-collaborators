module "securityanalytics-nmapscanner" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-nmapscanner"
  collaborators = {
    blackmamo    = "admin"
    progers-tech = "admin"
  }
}
