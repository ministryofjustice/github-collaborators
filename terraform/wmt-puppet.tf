module "wmt-puppet" {
  source     = "./modules/repository-collaborators"
  repository = "wmt-puppet"
  collaborators = [
    {
      github_user  = "Nathanials"
      permission   = "admin"
      name         = "Nathanial Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos manage the Workload Management Tool  (WMT) application"
      added_by     = "shazad.mohammed@digital.justice.gov.uk" # TODO: replace with WMT team email address
      review_after = "2021-04-01"
    },
    {
      github_user  = "kevinfox1"
      permission   = "admin"
      name         = "Kevin Fox"
      email        = "k.fox@kainos.com"
      org          = "Kainos"
      reason       = "Kainos manage the Workload Management Tool  (WMT) application"
      added_by     = "shazad.mohammed@digital.justice.gov.uk" # TODO: replace with WMT team email address
      review_after = "2021-04-01"
    },
    {
      github_user  = "Sam-Rodgers"
      permission   = "admin"
      name         = "Sam Rodgers"
      email        = "samro@kainos.com"
      org          = "Kainos"
      reason       = "Kainos manage the Workload Management Tool  (WMT) application"
      added_by     = "shazad.mohammed@digital.justice.gov.uk" # TODO: replace with WMT team email address
      review_after = "2021-06-30"
    },
  ]
}
