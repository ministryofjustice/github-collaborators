module "moj-cjse-xhibit-portal" {
  source     = "./modules/repository-collaborators"
  repository = "moj-cjse-xhibit-portal"
  collaborators = [
    {
      github_user  = "silvianahorga-al"
      permission   = "pull"
      name         = "Silviana-Andreea Horga"
      email        = "silviana.horga@digital.justice.gov.uk"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal repository"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "kevinb-v1-uk"
      permission   = "push"
      name         = "Kevin Brandon"
      email        = "kevin.brandon@version1.com"
      org          = "Version 1"
      reason       = "Needs to be able to view, submit and approve pull requests, push access to xhibit-portal repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "raydevlinv1"
      permission   = "push"
      name         = "Ray Devlin"
      email        = "ray.devlin@version1.com"
      org          = "Version 1"
      reason       = "Needs to be able to view, submit and approve pull requests, push access to xhibit-portal repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "jbantrotu"
      permission   = "push"
      name         = "Jagadeesh Bantrotu"
      email        = "jagadeesh.bantrotu@version1.com"
      org          = "Version 1"
      reason       = "Needs to be able to view, submit and approve pull requests, push access to xhibit-portal repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "zimboflyman"
      permission   = "admin"
      name         = "Shane Vanleeuwen"
      email        = "shane.vanleeuwen@version1.com"
      org          = "Version 1"
      reason       = "Needs to be able to view, submit and approve pull requests, push access to xhibit-portal repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "pawellas"
      permission   = "admin"
      name         = "Pawel Laskowski"
      email        = "pawel.laskowski@version1.com"
      org          = "Version 1"
      reason       = "Needs to be able to view, submit and approve pull requests, push access to xhibit-portal repositories"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
  ]
}
