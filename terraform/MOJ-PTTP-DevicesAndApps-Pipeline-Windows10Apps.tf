module "MOJ-PTTP-DevicesAndApps-Pipeline-Windows10Apps" {
  source     = "./modules/repository-collaborators"
  repository = "MOJ.PTTP.DevicesAndApps.Pipeline.Windows10Apps"
  collaborators = {
    JimGregory-SolTec = "admin"
  }
}
