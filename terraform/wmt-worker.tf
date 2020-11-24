module "wmt-worker" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-worker"
  collaborators = {
    willh = "admin"
    kylethompson = "push"
    andrew-js-wright = "push"
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
