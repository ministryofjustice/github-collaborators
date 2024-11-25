module "yjaf-serious-incidents" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-serious-incidents"
  collaborators = [
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-11-25"
    },
    {
      github_user  = "vasildimitrov22"
      permission   = "admin"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-12-12"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-01-11"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-01-13"
    },
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Want to amend logging settings for all microservices"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-01-05"
    },
    {
      github_user  = "fabiosalvarezza"
      permission   = "admin"
      name         = "Fabio Salvarezza"
      email        = "fabio.salvarezza@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-12-27"
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
    {
      github_user  = "jasongreen-necsws"
      permission   = "admin"
      name         = "Jason Green"
      email        = "jason.green@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-04-16"
    },
    {
      github_user  = "codebysachin"
      permission   = "push"
      name         = "Sachin Gupta"
      email        = "sachin.gupta@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-05-29"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "andrew.richards1@necsws.com"
      org          = "NEC SWS"
      reason       = "Existing developer"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-03-01"
    },
  ]
}
