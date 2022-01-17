module "hmpps-env-configs" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-env-configs"
  collaborators = [
    {
      github_user  = "swestb"
      permission   = "admin"
      name         = "Stuart Westbrook"
      email        = "stuart.westbrook@adrocgroup.com"
      org          = "Adroc Group"
      reason       = "In support of migration activities" #  Why is this person being granted access?
      added_by     = "maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2022-06-17"
    },
  ]
}
