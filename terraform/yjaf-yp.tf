module "yjaf-yp" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-yp"
  collaborators = {
    gregi2n = "admin"
    griffinjuknps = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
