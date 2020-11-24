module "apvs-alpha-ux" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-alpha-ux"
  collaborators = {
    tswann = "admin"
    chrisisk = "push"
    msjhall138 = "push"
    pwright08 = "push"
    csmith5 = "push"
  }
}
