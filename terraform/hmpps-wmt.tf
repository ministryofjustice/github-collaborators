module "hmpps-wmt" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-wmt"
  collaborators = {
    tswann = "admin"
    willh = "admin"
    andrew-js-wright = "push"
    stevenadams = "push"
    scoch = "push"
    dconey646 = "push"
  }
}
