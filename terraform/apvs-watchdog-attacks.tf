module "apvs-watchdog-attacks" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-watchdog-attacks"
  collaborators = {
    tswann           = "admin"
    msjhall138       = "push"
    pwright08        = "push"
    tmrowe           = "push"
    bensonarokiadoss = "push"
  }
}
