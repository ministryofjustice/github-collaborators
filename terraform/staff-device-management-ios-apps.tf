module "staff-device-management-ios-apps" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-ios-apps"
  collaborators = {
    JimGregory-SolTec = "admin"
    HughSolTec = "admin"
  }
}
