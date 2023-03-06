module "terraform-aws-step_function_globalprotect" {
  source     = "./modules/repository-collaborators"
  repository = "terraform-aws-step_function_globalprotect"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-06-02"
    },
  ]
}
