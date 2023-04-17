module "staff-device-private-dns-zone" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-private-dns-zone"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-19"
    },
  ]
}
