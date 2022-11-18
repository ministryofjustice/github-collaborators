module "MOJ-PTTP-DevicesAndApps-Pipeline-Windows10Apps" {
  source     = "./modules/repository-collaborators"
  repository = "MOJ.PTTP.DevicesAndApps.Pipeline.Windows10Apps"
  collaborators = [
    {
      github_user  = "JimGregory-CplusC"
      permission   = "admin"
      name         = "Jim Gregory"
      email        = "jim.gregory@contentandcloud.com"
      org          = "Content and Cloud"
      reason       = "PTTP Tech team"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2022-12-31"
    }
  ]
}
