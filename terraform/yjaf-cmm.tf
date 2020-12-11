module "yjaf-cmm" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-cmm"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "push"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
  ]
}
