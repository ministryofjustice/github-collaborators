module "testing-external-collaborators" {
  source     = "./modules/repository"
  repository = "testing-external-collaborators"
  collaborators = {
    DangerDawson = "push"
    toonsend     = "triage"
  }
}
