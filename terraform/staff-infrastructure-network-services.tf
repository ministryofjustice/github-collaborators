module "staff-infrastructure-network-services" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-network-services"
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
    }
  ]
}
