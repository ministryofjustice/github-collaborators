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
    {
      github_user  = "chubberlisk"
      permission   = "admin"
      name         = "wen ting wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-04-11"
    },
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-04-11"
    },
    {
      github_user  = "aprilmd"
      permission   = "admin"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-04-20"
    },
  ]
}
