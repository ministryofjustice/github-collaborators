module "bichard7-next" {
  source        = "./modules/repository-collaborators"
  repository    = "bichard7-next"
  collaborators = local.bichard7-collaborators
}
