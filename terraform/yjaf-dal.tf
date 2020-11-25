module "yjaf-dal" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-dal"
  collaborators = {
    gregi2n              = "admin"
    griffinjuknps        = "admin"
    AndrewRichards72     = "admin"
    TomDover-NorthgatePS = "push"
  }
}
