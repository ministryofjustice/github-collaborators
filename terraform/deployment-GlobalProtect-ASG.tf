module "deployment-GlobalProtect-ASG" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-GlobalProtect-ASG"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-20"
    },
  ]
}
