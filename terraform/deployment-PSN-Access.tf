module "deployment-PSN-Access" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-PSN-Access"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-19"
    },
  ]
}
