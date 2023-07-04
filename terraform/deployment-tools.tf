module "deployment-tools" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-tools"
  collaborators = [
    {
      github_user  = "joe-bsi"
      permission   = "maintain"
      name         = "joe beauchamp"
      email        = "[joe.beauchamp.bsi@gmail.com](mailto:joe.beauchamp.bsi@gmail.com)"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-02"
    },
  ]
}
