module "yjaf-ui" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-ui"
  collaborators = {
    chris-nps            = "push"
    gregi2n              = "admin"
    griffinjuknps        = "admin"
    AndrewRichards72     = "admin"
    TomDover-NorthgatePS = "push"
  }
}
