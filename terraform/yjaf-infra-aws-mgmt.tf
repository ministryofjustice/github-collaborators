module "yjaf-infra-aws-mgmt" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-infra-aws-mgmt"
  collaborators = [
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-02-19"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2023-12-18"
    },
    {
      github_user  = "markstanley-nps"
      permission   = "pull"
      name         = "Mark Stanley"
      email        = "mark.stanley@necsws.com"
      org          = "NECSWS"
      reason       = "Developer"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-02-15"
    },
  ]
}
