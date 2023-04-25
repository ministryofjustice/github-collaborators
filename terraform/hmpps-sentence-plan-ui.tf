module "hmpps-sentence-plan-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-sentence-plan-ui"
  collaborators = [
    {
      github_user  = "mcoffey-mt"
      permission   = "push"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-07-24"
    },
  ]
}
