module "send-legal-mail-to-prisons" {
  source     = "./modules/repository-collaborators"
  repository = "send-legal-mail-to-prisons"
  collaborators = [
    {
      github_user  = "rodonnell1-bsi"
      permission   = "push"
      name         = "richard odonnell"
      email        = "[richard.odonnell.testing1@bsigroup.com](mailto:richard.odonnell.testing1@bsigroup.com)"
      org          = "digital-prison-reporting"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-10-02"
    },
  ]
}
