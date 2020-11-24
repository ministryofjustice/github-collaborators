module "yjaf-gateway" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-gateway"
  collaborators = {
    brbaje-dev = "push"
    gregi2n = "admin"
    griffinjuknps = "admin"
    AndrewRichards72 = "admin"
    TomDover-NorthgatePS = "push"
  }
}
