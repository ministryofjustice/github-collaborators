module "yjaf-datateam" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-datateam"
  collaborators = [
    {
      github_user  = "sammohammeduk"
      permission   = "push"
      name         = "Sam Mohammed"
      email        = "sam.mohammed@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-06-16"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-06-15"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC SWS"
      reason       = "Requesting access so I can perhaps start sharing DB workload with Andrew"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-12-23"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "andrew.richards1@necsws.com"
      org          = "NEC SWS"
      reason       = "Existing developer"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-06-01"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-07-17"
    },
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Want to amend logging settings for all microservices"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-07-09"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-09-01"
    },
    {
      github_user  = "vasildimitrov22"
      permission   = "admin"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-08-31"
    },
    {
      github_user  = "fabiosalvarezza"
      permission   = "admin"
      name         = "Fabio Salvarezza"
      email        = "fabio.salvarezza@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-06-30"
    },
    {
      github_user  = "joharveynec"
      permission   = "pull"
      name         = "Jo Harvey"
      email        = "jo.harvey@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "To be able to view and manage vulnerabilities in YJAF code via Snyk"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-02-15"
    },
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-12-23"
    },
  ]
}
