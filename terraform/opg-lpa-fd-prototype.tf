module "opg-lpa-fd-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "opg-lpa-fd-prototype"
  collaborators = {
    UchennaN = "push"
  }
}
