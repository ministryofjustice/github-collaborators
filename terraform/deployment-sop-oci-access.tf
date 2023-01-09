module "deployment-sop-oci-access" {
  source     = "./modules/repository-collaborators"
  repository = "deployment-sop-oci-access"
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
    {
      github_user  = "nick"
      permission   = "maintain"
      name         = "nick walters"
      email        = "nick.walters@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "nick"
      review_after = "2023-10-10"
    },
  ]
}
