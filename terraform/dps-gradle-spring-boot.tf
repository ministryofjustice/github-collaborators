module "dps-gradle-spring-boot" {
  source     = "./modules/repository-collaborators"
  repository = "dps-gradle-spring-boot"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-24"
    },
  ]
}
