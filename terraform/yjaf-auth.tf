module "yjaf-auth" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-auth"
  collaborators = {
    gregi2n = "admin"
    griffinjuknps = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
