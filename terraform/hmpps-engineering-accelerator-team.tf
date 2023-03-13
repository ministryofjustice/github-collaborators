module "hmpps-engineering-accelerator-team" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-accelerator-team"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "pull"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "chubberlisk"
      permission   = "pull"
      name         = "wen ting wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "mcoffey-mt"
      permission   = "pull"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "emileswarts"
      permission   = "pull"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "bjpirt"
      permission   = "pull"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
  ]
}
