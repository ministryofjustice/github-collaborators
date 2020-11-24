module "yjaf-views" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-views"
  collaborators = {
    gregi2n = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
