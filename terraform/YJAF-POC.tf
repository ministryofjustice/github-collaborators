module "YJAF-POC" {
  source     = "./modules/repository-collaborators"
  repository = "YJAF-POC"
  collaborators = {
    oliviergaubert = "push"
    gregi2n = "admin"
  }
}
