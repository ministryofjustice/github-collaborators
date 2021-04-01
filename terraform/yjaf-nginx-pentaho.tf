module "yjaf-nginx-pentaho" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-nginx-pentaho"
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
      github_user  = "JWGNPS"
      permission   = "push"
      name         = "James Grunewald"
      email        = "james.grunewald@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@northgateps.com> Devops for northgate"
      review_after = "2022-01-27"
    },
    {
      github_user  = "VasilDimitrov22"
      permission   = "push"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@northgateps.com> Devops for northgate"
      review_after = "2021-12-31"
    },
  ]
}
