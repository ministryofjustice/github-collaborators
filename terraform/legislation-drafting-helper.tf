module "legislation-drafting-helper" {
  source     = "./modules/repository-collaborators"
  repository = "legislation-drafting-helper"
  collaborators = [
    {
      github_user  = "lmwilkigov"
      permission   = "write"
      name         = "Liam Wilkinson"
      email        = "liam.wilkinson@cabinetoffice.gov.uk"
      org          = "Cabinet Office / No10"
      reason       = "We are collaborating with no10 on a x-govt project relating to legislation."
      added_by     = "chloe.pugh1@justice.gov.uk"
      review_after = "2025-05-29"
    },
  ]
}
