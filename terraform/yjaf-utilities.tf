module "yjaf-utilities" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-utilities"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "brbaje-dev"
      permission   = "admin"
      name         = "Ben Bajek"
      email        = "ben.bajek@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@northgateps.com"
      review_after = "2022-12-31"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@northgateps.com"
      review_after = "2022-12-31"
    },
    {
      github_user  = "ConwayNEC"
      permission   = "push"
      name         = "Conway Hyacienth"
      email        = "conway.hyacienth@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New Front End Developer on YJAF (NEC team)"
      added_by     = "Jo Harvey - joanna.harvey@necsws.com"
      review_after = "2022-11-03"
    },
    {
      github_user  = "jondent"
      permission   = "push"
      name         = "Jon Dent"
      email        = "jon.dent@yjb.gov.uk"
      org          = "Youth Justice Board"
      reason       = "Technical Assurance Architect (managed service)"
      added_by     = "Jake Mulley (MOJ)"
      review_after = "2022-01-31"
    },
  ]
}
