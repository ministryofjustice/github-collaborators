module "staff-device-management-windows10-configuration" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-windows10-configuration"
  collaborators = {
    cyrusirandoust    = "push"
    JimGregory-SolTec = "admin"
    HughSolTec        = "admin"
  }
}
