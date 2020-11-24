module "yjaf-assets" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-assets"
  collaborators = {
    gregi2n = "admin"
    griffinjuknps = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
