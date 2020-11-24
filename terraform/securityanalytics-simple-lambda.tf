module "securityanalytics-simple-lambda" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-simple-lambda"
  collaborators = {
    blackmamo = "push"
    progers-tech = "push"
  }
}
