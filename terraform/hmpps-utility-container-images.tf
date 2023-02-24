module "hmpps-utility-container-images" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-utility-container-images"
  collaborators = [
    {
      github_user  = "mcoffey-mt"
      permission   = "push"
      name         = "matthew coffey"
      email        = "matthew.coffey@digital.justice.gov.uk"
      org          = "made tech"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-25"
    },
  ]
}
