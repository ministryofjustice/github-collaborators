module "acronyms" {
  source     = "./modules/repository-collaborators"
  repository = "acronyms"
  collaborators = {
    matthewtansini = "push"
    DangerDawson = "push"
  }
}
