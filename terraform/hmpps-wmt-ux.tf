module "hmpps-wmt-ux" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-wmt-ux"
  collaborators = {
    tswann = "admin"
    chrisisk = "push"
    andrew-js-wright = "push"
    stevenadams = "push"
    dconey646 = "push"
    caoimheb = "push"
  }
}
