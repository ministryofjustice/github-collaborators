module "yjaf-placements" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-placements"
  collaborators = {
    gregi2n              = "admin"
    griffinjuknps        = "admin"
    AndrewRichards72     = "admin"
    TomDover-NorthgatePS = "push"
  }
}
