module "testing-external-collaborators" {
  source     = "./modules/repository-collaborators"
  repository = "testing-external-collaborators"
  collaborators = [
    {
      github_user = "DangerDawson"
      permission  = "push"
      name        = "David Dawson"
      email       = "not@real.email"
    },
    {
      github_user = "toonsend"
      permission  = "triage"
      name        = "David Townsend"
      email       = "not@real.email"
    }
  ]
}
