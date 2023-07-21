module "yjaf-mule-mis-processor" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-mule-mis-processor"
  collaborators = [
    {
      github_user  = "stephenhobden"
      permission   = "admin"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NECSWS"
      reason       = "Want to amend logging settings for all microservices"
      added_by     = "Mick.Ewers@yjb.gov.uk"
      review_after = "2024-07-09"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2024-07-17"
    },
  ]
}
