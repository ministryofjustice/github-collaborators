module "securityanalytics-analyticsplatform" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-analyticsplatform"
  collaborators = {
    blackmamo    = "admin"
    progers-tech = "admin"
  }
}
