module "apply-for-compensation-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "apply-for-compensation-prototype"
  collaborators = [
    {
      github_user  = "jp-bsi"
      permission   = "admin"
      name         = "joe phee"
      email        = "joseph.phee@bsigroup.com"
      org          = "bsi"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-20"
    },
  ]
}
