module "hmpps-sentence-plan" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-sentence-plan"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "push"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-09-03"
    },
  ]
}
