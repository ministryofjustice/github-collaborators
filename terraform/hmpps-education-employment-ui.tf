module "hmpps-education-employment-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-education-employment-ui"
  collaborators = [
    {
      github_user  = "joe-bsi"
      permission   = "push"
      name         = "joe beauchamp"
      email        = "joe.beauchamp.bsi@gmail.com"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-13"
    },
  ]
}
