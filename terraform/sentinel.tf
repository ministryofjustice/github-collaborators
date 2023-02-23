module "sentinel" {
  source     = "./modules/repository-collaborators"
  repository = "sentinel"
  collaborators = [
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "simon barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "civica"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-24"
    },
  ]
}
