module "hmpps-delius-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-delius-api"
  collaborators = [
    {
      github_user  = "mlaskowski4"
      permission   = "push"
      name         = "Michal Laskowski"
      email        = "mlaskowski@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "peter-bcl"
      permission   = "push"
      name         = "Peter Wilson"
      email        = "pwilson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "seanvalmonte"
      permission   = "push"
      name         = "Sean Valmonte"
      email        = "svalmonte@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2023-08-25"
    },
    {
      github_user  = "joe-bsi"
      permission   = "push"
      name         = "joe beauchamp"
      email        = "[joe.beauchamp.bsi@gmail.com](mailto:joe.beauchamp.bsi@gmail.com)"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-09"
    },
  ]
}
