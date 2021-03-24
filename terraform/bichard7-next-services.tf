module "bichard7-next-services" {
  source        = "./modules/repository-collaborators"
  repository    = "bichard7-next-services"
  collaborators = local.bichard7-collaborators
}
