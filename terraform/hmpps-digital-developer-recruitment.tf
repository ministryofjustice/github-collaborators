module "hmpps-digital-developer-recruitment" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-digital-developer-recruitment"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "pull"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-24"
    },
  ]
}
