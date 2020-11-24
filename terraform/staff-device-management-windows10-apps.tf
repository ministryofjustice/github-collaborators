module "staff-device-management-windows10-apps" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-windows10-apps"
  collaborators = {
    cyrusirandoust = "push"
    JimGregory-SolTec = "admin"
    HughSolTec = "admin"
  }
}
