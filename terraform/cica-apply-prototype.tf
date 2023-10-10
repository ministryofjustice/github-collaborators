module "cica-apply-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "cica-apply-prototype"
  collaborators = [
    {
      github_user  = "msenkiw"
      permission   = "push"
      name         = "michael senkiw"
      email        = "michael.senkiw@informed.com"
      org          = "informed solutions"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-25"
    },
    {
      github_user  = "jack-burt-is"
      permission   = "push"
      name         = "jack burt"
      email        = "jack.burt@informed.com"
      org          = "informed solutions"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-25"
    },
    {
      github_user  = "dr103"
      permission   = "push"
      name         = "daniel rex"
      email        = "daniel.rex@informed.com"
      org          = "informed solutions"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-25"
    },
  ]
}
