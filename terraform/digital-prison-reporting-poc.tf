module "digital-prison-reporting-poc" {
  source     = "./modules/repository-collaborators"
  repository = "digital-prison-reporting-poc"
  collaborators = [
    {
      github_user  = "rodonnell1-bsi"
      permission   = "admin"
      name         = "richard odonnell"
      email        = "richard.odonnell.testing1@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-13"
    },
  ]
}
