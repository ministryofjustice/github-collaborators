module "bichard7-next-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "bichard7-next-infrastructure"
  collaborators = {
    bjpirt = "admin"
    LewisDaleUK = "push"
    sioldham = "push"
    ccp92 = "admin"
    Ninamma = "push"
    jessicatech = "pull"
    aman-automationlogic = "pull"
    TheGrantsta = "push"
  }
}
