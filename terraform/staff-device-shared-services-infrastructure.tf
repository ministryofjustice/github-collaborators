module "staff-device-shared-services-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-shared-services-infrastructure"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
    {
      github_user  = "C-gyorfi"
      permission   = "admin"
      name         = "Csaba Gyorfi"
      email        = "csaba@madetech.com"
      org          = "Madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-22"
    },
  ]
}
