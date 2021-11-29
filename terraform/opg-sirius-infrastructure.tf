module "opg-sirius-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "opg-sirius-infrastructure"
  collaborators = [
    {
      github_user  = "bsi-thudson"
      permission   = "pull"
      name         = "Thomas Hudson"
      email        = "thomas.hudson@bsigroup.com "
      org          = "BSI"
      reason       = "ITHC Testing"
      added_by     = "thomas.withers@justice.gov.uk"
      review_after = "2022-12-06"
    }
  ]
}
