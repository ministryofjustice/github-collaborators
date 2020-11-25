module "wmt-probation-rules" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-probation-rules"
  collaborators = {
    willh            = "admin"
    kylethompson     = "push"
    andrew-js-wright = "push"
    Nathanials       = "admin"
    kevinfox1        = "admin"
  }
}
