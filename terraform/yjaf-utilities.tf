module "yjaf-utilities" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-utilities"
  collaborators = [
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-07-15"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New YJAF Full Stack Developer"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-05-02"
    },
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
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-06-30"
    },
    {
      github_user  = "fabiosalvarezza"
      permission   = "admin"
      name         = "Fabio Salvarezza"
      email        = "fabio.salvarezza@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-06-30"
    },
    {
      github_user  = "joharveynec"
      permission   = "pull"
      name         = "Jo Harvey"
      email        = "jo.harvey@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "To be able to view and manage vulnerabilities in YJAF code via Snyk"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2025-02-15"
    },
  ]
}
