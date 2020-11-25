module "staff-device-dns-dhcp-admin" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-dns-dhcp-admin"
  collaborators = {
    Themitchell = "admin"
    neilkidd    = "admin"
    jivdhaliwal = "admin"
    CaitBarnard = "admin"
    jbevan4     = "admin"
    efuaakum    = "admin"
  }
}
