module "yjaf-infra-aws-mgmt" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-infra-aws-mgmt"
  collaborators = [
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-06-15"
    },
  ]
}
