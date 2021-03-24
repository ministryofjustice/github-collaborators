module "moj-cjse-bichard7" {
  source        = "./modules/repository-collaborators"
  repository    = "moj-cjse-bichard7"
  collaborators = local.bichard7-collaborators
}
