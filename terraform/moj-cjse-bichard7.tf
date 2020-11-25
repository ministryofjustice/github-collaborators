module "moj-cjse-bichard7" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-bichard7"
  collaborators = {
    bjpirt      = "admin"
    mdavix      = "pull"
    LewisDaleUK = "pull"
    sioldham    = "push"
    Ninamma     = "pull"
    R1chardA    = "push"
    sotaylor    = "push"
    rdc1969     = "push"
    jessicatech = "pull"
    TheGrantsta = "pull"
  }
}
