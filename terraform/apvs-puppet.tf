module "apvs-puppet" {
  source     = "./modules/repository-collaborators"
  repository = "apvs-puppet"
  collaborators = [
    {
      github_user  = "Nathanials"
      permission   = "admin"
      name         = "Nathanial Stewart"
      email        = "n.stewart@kainos.com"
      org          = "Kainos"
      reason       = "Kainos manage the Assisted Prison Visits Scheme (APVS) application"
      added_by     = "phoebe.crossland@digital.justice.gov.uk" # TODO: replace with APVS team email address
      review_after = "2021-04-01"
    },
    {
      github_user  = "kevinfox1"
      permission   = "admin"
      name         = "Kevin Fox"
      email        = "k.fox@kainos.com"
      org          = "Kainos"
      reason       = "Kainos manage the Assisted Prison Visits Scheme (APVS) application"
      added_by     = "phoebe.crossland@digital.justice.gov.uk" # TODO: replace with APVS team email address
      review_after = "2021-04-01"
    },
  ]
}
