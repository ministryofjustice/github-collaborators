module "hmpps-integration-api-docs" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-integration-api-docs"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-04-11"
    },
    {
      github_user  = "mcoffey-mt"
      permission   = "admin"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-04-11"
    },
  ]
}
