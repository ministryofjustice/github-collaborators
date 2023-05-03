module "aws-root-account" {
  source     = "./modules/repository-collaborators"
  repository = "aws-root-account"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "triage"
      name         = "Ben Pirt"
      email        = "ben@madetech.com"
      org          = "Madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-19"
    },
  ]
}
