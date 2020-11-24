module "laa-benefitchecker-1-0-big" {
  source     = "./modules/repository-collaborators"
  repository = "laa-benefitchecker-1.0-big"
  collaborators = {
    abelsky = "push"
  }
}
