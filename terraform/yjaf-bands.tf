module "yjaf-bands" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-bands"
  collaborators = {
    gregi2n = "admin"
    griffinjuknps = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
