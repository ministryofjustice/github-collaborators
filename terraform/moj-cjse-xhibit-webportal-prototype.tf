module "moj-cjse-xhibit-webportal-prototype" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-xhibit-webportal-prototype"
  collaborators = [
    {
      github_user  = "kevinb-v1-uk"
      permission   = "admin"
      name         = "Kevin Brandon"
      email        = "kevin.brandon@version1.com"
      org          = "Version 1"
      reason       = "Needs to be able to view, submit and approve pull requests, push access to xhibit-portal repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "raydevlinv1"
      permission   = "admin"
      name         = "Ray Devlin"
      email        = "ray.devlin@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to xhibit-portal-prototype repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "petewv1"
      permission   = "admin"
      name         = "Peter Wightman"
      email        = "peter.wightman@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to xhibit-portal-prototype repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "jbantrotu"
      permission   = "admin"
      name         = "Jagadeesh Bantrotu"
      email        = "jagadeesh.bantrotu@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to xhibit-portal-prototype repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "zimboflyman"
      permission   = "admin"
      name         = "Shane Vanleeuwen"
      email        = "shane.vanleeuwen@version1.com"
      org          = "Version 1"
      reason       = "Needs admin rights to xhibit-portal-prototype repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
  ]
}
