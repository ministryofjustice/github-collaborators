module "opg-org-infra" {
  source     = "./modules/repository-collaborators"
  repository = "opg-org-infra"
  collaborators = [
    {
      github_user  = "bsi-thudson"
      permission   = "pull"
      name         = "Thomas Hudson"
      email        = "thomas.hudson@bsigroup.com"
      org          = "BSI"
      reason       = "ITHC Testing"
      added_by     = "thomas.withers@justice.gov.uk"
      review_after = "2021-12-06"
    }
  ]
}
