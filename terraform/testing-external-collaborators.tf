module "testing-external-collaborators" {
  source     = "./modules/repository-collaborators"
  repository = "testing-external-collaborators"
  collaborators = {
    toonsend     = "triage"
  }
}
