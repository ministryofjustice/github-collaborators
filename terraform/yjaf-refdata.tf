module "yjaf-refdata" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-refdata"
  collaborators = {
    gregi2n              = "admin"
    TomDover-NorthgatePS = "push"
  }
}
