module "pttp-shared-services-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "pttp-shared-services-infrastructure"
  collaborators = {
    Themitchell = "admin"
    thip = "admin"
    neilkidd = "admin"
    jivdhaliwal = "admin"
    elena-vi = "admin"
    chubberlisk = "admin"
    CaitBarnard = "admin"
    jbevan4 = "admin"
    efuaakum = "admin"
  }
}
