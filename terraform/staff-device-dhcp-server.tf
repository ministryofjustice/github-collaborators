module "staff-device-dhcp-server" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-dhcp-server"
  collaborators = {
    Themitchell = "admin"
    thip        = "admin"
    neilkidd    = "admin"
    jivdhaliwal = "admin"
    CaitBarnard = "admin"
    jbevan4     = "admin"
    efuaakum    = "admin"
  }
}
