module "ndelius-um" {
  source     = "./modules/repository-collaborators"
  repository = "ndelius-um"
  collaborators = [
    {
      github_user  = "peter-bcl"
      permission   = "push"
      name         = "Peter Wilson"
      email        = "pwilson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Marcus Aspin <marcus.aspin@digital.justice.gov.uk>"
      review_after = "2023-12-29"
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
