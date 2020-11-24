module "andalusia" {
  source     = "./modules/repository-collaborators"
  repository = "andalusia"
  collaborators = {
    blackmamo = "pull"
    progers-tech = "pull"
  }
}
