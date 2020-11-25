module "yjaf-documents" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-documents"
  collaborators = {
    gregi2n              = "admin"
    griffinjuknps        = "admin"
    AndrewRichards72     = "admin"
    TomDover-NorthgatePS = "push"
  }
}
