module "dps-smoketest" {
  source     = "./modules/repository-collaborators"
  repository = "dps-smoketest"
  collaborators = [
    {
      github_user  = "rodonnell1-bsi"
      permission   = "push"
      name         = "richard odonnell"
      email        = "[richard.odonnell.testing1@bsigroup.com](mailto:richard.odonnell.testing1@bsigroup.com)"
      org          = "digital-prison-reporting"
      reason       = "IT Health Check"
      added_by     = "hari.chintala@digital.justice.gov.uk"
      review_after = "2023-08-30"
    },
    {
      github_user  = "joe-bsi"
      permission   = "push"
      name         = "joe beauchamp"
      email        = "[joe.beauchamp.bsi@gmail.com](mailto:joe.beauchamp.bsi@gmail.com)"
      org          = "digital-prison-reporting"
      reason       = "IT Health Check"
      added_by     = "hari.chintala@digital.justice.gov.uk"
      review_after = "2023-08-30"
    },
    {
      github_user  = "aprilmd"
      permission   = "push"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-09"
    },
  ]
}
