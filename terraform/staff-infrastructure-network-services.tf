module "staff-infrastructure-network-services" {
  source     = "./modules/repository-collaborators"
  repository = "staff-infrastructure-network-services"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "maintain"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-19"
    },
  ]
}
