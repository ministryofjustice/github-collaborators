module "securityanalytics-sslscanner" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-sslscanner"
  collaborators = {
    blackmamo = "admin"
    progers-tech = "admin"
  }
}
