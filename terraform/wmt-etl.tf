module "wmt-etl" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-etl"
  collaborators = {
    kylethompson = "push"
    Nathanials   = "admin"
    kevinfox1    = "admin"
  }
}
