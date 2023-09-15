module "cloud-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "cloud-platform-environments"
  collaborators = [
    {
      github_user  = "bsi0714"
      permission   = "pull"
      name         = "Daniel Elliott"
      email        = "Daniel.elliott@bsigroup.com"
      org          = "BSI"
      reason       = "CICA IT Health Check"
      added_by     = "adrian.roworth@digitial.justice.gov.uk"
      review_after = "2023-10-13"
    },
    {
      github_user  = "jp-bsi"
      permission   = "pull"
      name         = "Joe Phee"
      email        = "joseph.phee@bsigroup.com"
      org          = "BSI"
      reason       = "CICA IT Health Check"
      added_by     = "adrian.roworth@digitial.justice.gov.uk"
      review_after = "2023-10-13"
    },
  ]
}
