module "gangs-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "gangs-prototype"
  collaborators = {
    johnmildinhall = "admin"
  }
}
