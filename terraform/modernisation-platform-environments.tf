module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "nbuckingham72"
      permission   = "push"
      name         = "nick buckingham"
      email        = "nick.buckingham@lumen.com"
      org          = "Lumen Technologies"
      reason       = "The user will manage the PPUD terraform code on day to day basis"
      added_by     = "mark.hardy@digital.justice.gov.uk"
      review_after = "2025-06-12"
    },
    {
      github_user  = "jamesashton-roc"
      permission   = "push"
      name         = "James Ashton"
      email        = "james.ashton@roctechnologies.com"
      org          = "ROC"
      reason       = "Get access to equip github actions on Modernisation Platform"
      added_by     = "edward.proctor@digital.justice.gov.uk"
      review_after = "2025-06-12"
    },
    {
      github_user  = "djcostin"
      permission   = "push"
      name         = "Daniel Costin"
      email        = "daniel.costin@digital.justice.gov.uk"
      org          = "Modular Data"
      reason       = "Onboarding of new full stack developer, needs access for day to day work."
      added_by     = "mark.mckeown@digital.justice.gov.uk"
      review_after = "2025-03-31"
    },
    {
      github_user  = "gemmamills01"
      permission   = "pull"
      name         = "Gemma Mills"
      email        = "gemma.mills@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Get access to Delius-IAPS on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2025-05-01"
    },
    {
      github_user  = "gregi2n"
      permission   = "push"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "External DevOps engineer for Youth Justice App Framework on Modernisation Platform"
      added_by     = "david.sibley@digital.justice.gov.uk"
      review_after = "2025-12-13"
    },
    {
      github_user  = "ttipler"
      permission   = "push"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "External DevOps engineer for Youth Justice App Framework on Modernisation Platform"
      added_by     = "david.sibley@digital.justice.gov.uk"
      review_after = "2025-12-13"
    },
    {
      github_user  = "jasongreen-necsws"
      permission   = "push"
      name         = "Jason Green"
      email        = "jason.green@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "External DevOps engineer for Youth Justice App Framework on Modernisation Platform"
      added_by     = "david.sibley@digital.justice.gov.uk"
      review_after = "2025-12-13"
    },
    {
      github_user  = "davidseekins"
      permission   = "push"
      name         = "David Seekins"
      email        = "david.seekins@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "External DevOps engineer for Youth Justice App Framework on Modernisation Platform"
      added_by     = "david.sibley@digital.justice.gov.uk"
      review_after = "2025-12-13"
    },
    {
      github_user  = "stephenhobden"
      permission   = "push"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "External DevOps engineer for Youth Justice App Framework on Modernisation Platform"
      added_by     = "david.sibley@digital.justice.gov.uk"
      review_after = "2025-12-13"
    },
  ]
}
