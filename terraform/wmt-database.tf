module "wmt-database" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-database"
  collaborators = {
    tswann           = "admin"
    andrew-js-wright = "admin"
    ddebella         = "push"
  }
}
