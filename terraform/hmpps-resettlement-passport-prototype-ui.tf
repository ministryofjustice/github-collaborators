module "hmpps-resettlement-passport-prototype-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-resettlement-passport-prototype-ui"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "push"
      name         = "ben pirt"
      email        = "ben@madetech.com"
      org          = "madetech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-09-14"
    },
  ]
}
