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
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-05-02"
    },
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Developer Requiring access to work on gateway-proxy project"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-05-02"
    },
    {
      github_user  = "necpgilgunn"
      permission   = "pull"
      name         = "Philip Gilgunn"
      email        = "philip.gilgunn@necsws.com"
      org          = "NECSWS"
      reason       = "Head of Technology"
      added_by     = "mick.ewers@yjb.gov.uk"
      review_after = "2024-05-02"
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
  ]
}
