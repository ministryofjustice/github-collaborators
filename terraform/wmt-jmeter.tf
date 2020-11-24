module "wmt-jmeter" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-jmeter"
  collaborators = {
    andrew-js-wright = "admin"
    Nathanials = "admin"
    kevinfox1 = "admin"
  }
}
