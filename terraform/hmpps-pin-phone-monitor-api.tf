module "hmpps-pin-phone-monitor-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-pin-phone-monitor-api"
  collaborators = [
    {
      github_user  = "dwin998"
      permission   = "pull"
      name         = "Duncan Winfrey"
      email        = "duncan.winfrey@bsicsiruk.cjsm.net"
      org          = "BSI"
      reason       = "Allow BSI pen testers to review internal code repo"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of BSI"
      review_after = "2021-04-10"
    },
  ]
}
