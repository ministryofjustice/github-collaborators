module "delius-manual-deployments" {
  source     = "./modules/repository-collaborators"
  repository = "delius-manual-deployments"
  collaborators = [
    {
      github_user  = "yfedkiv"
      permission   = "admin"
      name         = "Yuri Fedkiv"
      email        = "yfedviv@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "marcus.aspin@digital.justice.gov.uk"
      review_after = "2025-06-01"
    },
    {
      github_user  = "DavidJohnReid"
      permission   = "admin"
      name         = "David Reid"
      email        = "dreid@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "marcus.aspin@digital.justice.gov.uk"
      review_after = "2025-06-01"
    }
  ]
}
