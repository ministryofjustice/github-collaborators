module "transit-gateways" {
  source     = "./modules/repository-collaborators"
  repository = "transit-gateways"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "maintain"
      name         = "Emile Swarts"
      email        = "emile@madetech.com"
      org          = "Made Tech Ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-19"
    },
    {
      github_user  = "nick123"
      permission   = "pull"
      name         = "nick walters"
      email        = "nick@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "Nick Walters nick.walters@digital.justice.gov.uk"
      review_after = "2023-07-11"
    },
    {
      github_user  = "bob123"
      permission   = "pull"
      name         = "bob smith"
      email        = "bob@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "Nick Walters nick.walters@digital.justice.gov.uk"
      review_after = "2023-07-11"
    },
    {
      github_user  = "john123"
      permission   = "pull"
      name         = "john hope"
      email        = "john@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "Nick Walters nick.walters@digital.justice.gov.uk"
      review_after = "2023-07-11"
    },
  ]
}
