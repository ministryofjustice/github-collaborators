module "child-arrangements-checklist-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "child-arrangements-checklist-prototype"
  collaborators = {
    richspencer = "push"
  }
}
