module "staff-device-shared-services-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-shared-services-infrastructure"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-19"
    },
    {
      github_user  = "c-gyorfi"
      permission   = "admin"
      name         = "csaba gyorfi"
      email        = "csaba@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-03"
    },
  ]
}
