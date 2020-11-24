module "moj-signon" {
  source     = "./modules/repository-collaborators"
  repository = "moj-signon"
  collaborators = {
    kentsanggds = "pull"
  }
}
