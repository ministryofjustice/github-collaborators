module "staff-device-dns-server" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-dns-server"
  collaborators = {
    Themitchell = "admin"
    neilkidd = "admin"
    jivdhaliwal = "admin"
    jbevan4 = "admin"
    efuaakum = "admin"
  }
}
