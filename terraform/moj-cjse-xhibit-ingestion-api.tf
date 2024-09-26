module "moj-cjse-xhibit-ingestion-api" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-xhibit-ingestion-api"
  collaborators = [
    {
      github_user  = "kevinb-v1-uk"
      permission   = "admin"
      name         = "Kevin Brandon"
      email        = "kevin.brandon@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to moj-cjse-xhibit-ingestion-api repository"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "jbantrotu"
      permission   = "admin"
      name         = "Jagadeesh Bantrotu"
      email        = "jagadeesh.bantrotu@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to moj-cjse-xhibit-ingestion-api repository"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "petewv1"
      permission   = "admin"
      name         = "Peter Wightman"
      email        = "peter.wightman@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to moj-cjse-xhibit-ingestion-api repository"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "zimboflyman"
      permission   = "admin"
      name         = "Shane Vanleeuwen"
      email        = "shane.vanleeuwen@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to moj-cjse-xhibit-ingestion-api repository"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "pawellas"
      permission   = "admin"
      name         = "Pawel Laskowski"
      email        = "pawel.laskowski@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to moj-cjse-xhibit-ingestion-api repository"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
  ]
}
