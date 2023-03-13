module "deployment-tools" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-tools"
  collaborators = [
    {
      github_user  = "aprilmd"
      permission   = "maintain"
      name         = "april dawson"
      email        = "april.dawson@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "chubberlisk"
      permission   = "maintain"
      name         = "wen ting wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "mcoffey-mt"
      permission   = "maintain"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "emileswarts"
      permission   = "maintain"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
    {
      github_user  = "bjpirt"
      permission   = "maintain"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "Made Tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-08"
    },
  ]
}
