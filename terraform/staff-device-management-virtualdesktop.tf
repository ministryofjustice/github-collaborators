module "staff-device-management-virtualdesktop" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-virtualdesktop"
  collaborators = [
    {
      github_user  = "VinceThompson"
      permission   = "push"
      name         = "Vince Thompson"
      email        = "vthompson@contentandcloud.com"
      org          = "Content and Cloud"
      reason       = "PTTP Tech Team"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2022-12-31"
    },
    {
      github_user  = "BenSnapeCC"
      permission   = "push"
      name         = "Ben Snape"
      email        = "ben.snape@contentandcloud.com"
      org          = "Content and Cloud"
      reason       = "PTTP Tech Team"
      added_by     = "matthew.white1@justice.gov.uk"
      review_after = "2022-12-31"
    }
  ]
}
