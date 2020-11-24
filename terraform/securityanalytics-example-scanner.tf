module "securityanalytics-example-scanner" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-example-scanner"
  collaborators = {
    progers-tech = "admin"
  }
}
