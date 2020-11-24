module "wmt-web" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-web"
  collaborators = {
    willh = "admin"
    kylethompson = "push"
    andrew-js-wright = "admin"
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
