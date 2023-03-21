module "ndelius-serenity-automation" {
  source     = "./modules/repository-collaborators"
  repository = "ndelius-serenity-automation"
  collaborators = [
    {
      github_user  = "mlaskowski4"
      permission   = "admin"
      name         = "Michal Laskowski"
      email        = "mlaskowski@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "Nicola Hodgkinson <nicola.hodgkinson@justice.gov.uk>"
      review_after = "2024-03-21"
    },
  ]
}
