module "hmpps-engineering-accelerator-team" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-accelerator-team"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "pull"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-24"
    },
  ]
}
