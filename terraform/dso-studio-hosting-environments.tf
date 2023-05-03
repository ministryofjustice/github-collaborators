module "dso-studio-hosting-environments" {
  source     = "./modules/repository-collaborators"
  repository = "dso-studio-hosting-environments"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-01"
    },
  ]
}
