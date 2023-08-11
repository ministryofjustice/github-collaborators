module "hmpps-digital-prison-reporting-mi" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-digital-prison-reporting-mi"
  collaborators = [
    {
      github_user  = "joe-bsi"
      permission   = "admin"
      name         = "joe beauchamp"
      email        = "[joe.beauchamp.bsi@gmail.com](mailto:joe.beauchamp.bsi@gmail.com)"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-09"
    },
  ]
}
