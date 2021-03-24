module "bichard7-next-infrastructure" {
  source        = "./modules/repository-collaborators"
  repository    = "bichard7-next-infrastructure"
  collaborators = local.bichard7-collaborators
}
