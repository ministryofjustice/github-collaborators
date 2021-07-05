module "staff-infrastructure-monitoring-snmpexporter" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-monitoring-snmpexporter"
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
  ]
}
