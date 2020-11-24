module "HMPPS-propose-a-new-digital-service" {
  source     = "./modules/repository-collaborators"
  repository = "HMPPS-propose-a-new-digital-service"
  collaborators = {
    dominion79 = "admin"
  }
}
