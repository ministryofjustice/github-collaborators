module "sentinel" {
  source     = "./modules/repository-collaborators"
  repository = "sentinel"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "admin"
      name         = "simon creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "civica"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-24"
    },
  ]
}
