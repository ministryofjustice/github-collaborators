module "cts-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "cts-prototype"
  collaborators = {
    jkosem = "admin"
  }
}
