module "staff-device-dns-dhcp-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-dns-dhcp-infrastructure"
  collaborators = {
    Themitchell = "admin"
    thip = "admin"
    neilkidd = "admin"
    jivdhaliwal = "admin"
    CaitBarnard = "admin"
    jbevan4 = "admin"
    efuaakum = "admin"
  }
}
