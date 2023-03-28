module "laa-aws-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "laa-aws-infrastructure"
  collaborators = [
    {
      github_user  = "tundeajewole"
      permission   = "push"
      name         = "Tunde Ajewole"
      email        = "tunde@automationlogic.com"
      org          = "Automation Logic"
      reason       = "Temp access whilst account recovery ongoing"
      added_by     = "ben.ashton@digital.justice.gov.uk"
      review_after = "2023-04-26"
    },
  ]
}
