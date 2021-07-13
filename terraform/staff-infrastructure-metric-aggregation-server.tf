module "staff-infrastructure-metric-aggregation-server" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-metric-aggregation-server"
  collaborators = [
    {
      github_user  = "thip"
      permission   = "admin"
      name         = "David Capper"
      email        = "david.capper@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@justice.gov.uk"
      review_after = "2021-10-31"
    },
    {
      github_user  = "richrace"
      permission   = "admin"
      name         = "Richard Race"
      email        = "richard.race@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "PTTP Tech Team"
      added_by     = "richard.baguley@digital.justice.gov.uk"
      review_after = "2021-10-31"
    }
  ]
}
