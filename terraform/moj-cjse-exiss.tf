module "moj-cjse-exiss" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-exiss"
  collaborators = {
    bjpirt = "admin"
    LewisDaleUK = "pull"
    Ninamma = "pull"
    R1chardA = "push"
    sotaylor = "push"
    phillipread = "push"
    jimgraley-soprasteria = "push"
    jessicatech = "pull"
    TheGrantsta = "pull"
  }
}
