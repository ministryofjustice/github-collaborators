module "help-with-prison-visits-asynchronous-worker" {
  source     = "./modules/repository-collaborators"
  repository = "help-with-prison-visits-asynchronous-worker"
  collaborators = [
    {
      github_user  = "chubberlisk"
      permission   = "push"
      name         = "wen ting wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-12-26"
    },
  ]
}
