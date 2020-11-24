module "apvs-database-migrations" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-database-migrations"
  collaborators = {
    tswann = "admin"
    msjhall138 = "push"
    pwright08 = "push"
    tmrowe = "push"
  }
}
