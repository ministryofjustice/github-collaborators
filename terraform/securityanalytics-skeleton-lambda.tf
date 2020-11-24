module "securityanalytics-skeleton-lambda" {
  source     = "./modules/repository-collaborators"
  repository = "securityanalytics-skeleton-lambda"
  collaborators = {
    progers-tech = "push"
  }
}
