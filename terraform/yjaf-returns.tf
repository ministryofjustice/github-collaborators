module "yjaf-returns" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-returns"
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
      github_user  = "TomDover-NorthgatePS"
      permission   = "push"
      name         = "Tom Dover"
      email        = "tom.dover@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
  ]
}
