module "hmpps-central-session-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-central-session-api"
  collaborators = [
    {
      github_user  = "rodonnell1-bsi"
      permission   = "push"
      name         = "richard odonnell"
      email        = "richard.odonnell.testing1@bsigroup.com"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-11-13"
    },
  ]
}