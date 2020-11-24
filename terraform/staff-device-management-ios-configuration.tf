module "staff-device-management-ios-configuration" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-ios-configuration"
  collaborators = {
    JimGregory-SolTec = "admin"
    HughSolTec = "admin"
  }
}
