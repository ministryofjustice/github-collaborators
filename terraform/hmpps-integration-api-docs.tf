module "hmpps-integration-api-docs" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-integration-api-docs"
  collaborators = [
    {
      github_user  = "chubberlisk"
      permission   = "admin"
      name         = "wen ting wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-29"
    },
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-29"
    },
    {
      github_user  = "aprilmd"
      permission   = "admin"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2024-04-26"
    },
  ]
}
