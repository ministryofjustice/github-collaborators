module "yjaf-gateway-proxy" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-gateway-proxy"
  collaborators = [
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Developer Requiring access to work on gateway-proxy project"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-12-23"
    },
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Developer Requiring access to work on gateway-proxy project"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-05-02"
    },
    {
      github_user  = "necpgilgunn"
      permission   = "pull"
      name         = "Philip Gilgunn"
      email        = "philip.gilgunn@necsws.com"
      org          = "NECSWS"
      reason       = "Head of Technology"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2024-10-29"
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
      github_user  = "vasildimitrov22"
      permission   = "admin"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-02-16"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "push"
      name         = "Andrew Richards"
      email        = "andrew.richards1@necsws.com"
      org          = "NEC SWS"
      reason       = "To be able to continue development of the project as architect/developer"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-04-04"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "David.Hall@yjb.gov.uk"
      review_after = "2025-04-22"
    },
  ]
}
