module "ttg-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "ttg-prototype"
  collaborators = {
    John-Beale = "push"
  }
}
