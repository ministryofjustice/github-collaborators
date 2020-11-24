module "yjaf-cmm" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-cmm"
  collaborators = {
    gregi2n = "push"
  }
}
