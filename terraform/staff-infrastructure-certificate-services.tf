module "staff-infrastructure-certificate-services" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-certificate-services"
  collaborators = {
    thip = "push"
  }
}
