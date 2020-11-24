module "yjaf-bed-unlock" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-bed-unlock"
  collaborators = {
    gregi2n = "admin"
    griffinjuknps = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
