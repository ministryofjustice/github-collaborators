module "deployment-SOP-OCI-Access" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-SOP-OCI-Access"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-16"
    },
  ]
}
