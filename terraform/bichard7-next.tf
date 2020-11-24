module "bichard7-next" {
  source     = "./modules/repository-collaborators"
  repository = "bichard7-next"
  collaborators = {
    bjpirt = "admin"
    mdavix = "pull"
    LewisDaleUK = "push"
    sioldham = "push"
    ccp92 = "admin"
    Ninamma = "push"
    jessicatech = "pull"
    aman-automationlogic = "pull"
    TheGrantsta = "push"
  }
}
