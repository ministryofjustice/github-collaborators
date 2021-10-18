module "staff-infrastructure-monitoring-deployments" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-deployments"
  collaborators = [
    {
      github_user  = "richrace"
      permission   = "admin"
      name         = "Richard Race"
      email        = "richard.race@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@digital.justice.gov.uk"
      review_after = "2021-10-31"
    },
    {
      github_user  = "neilkidd"
      permission   = "admin"
      name         = "Neil Kidd"
      email        = "neil.kidd@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "aaron.robinson@digital.justice.gov.uk"
      review_after = "2022-04-31"
    }
  ]
}