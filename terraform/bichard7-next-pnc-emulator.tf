module "bichard7-next-pnc-emulator" {
  source        = "./modules/repository-collaborators"
  repository    = "bichard7-next-pnc-emulator"
  collaborators = local.bichard7-collaborators
}
