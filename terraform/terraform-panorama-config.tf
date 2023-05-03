module "terraform-panorama-config" {
  source     = "./modules/repository-collaborators"
  repository = "terraform-panorama-config"
  collaborators = [
  ]
}
