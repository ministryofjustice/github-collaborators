module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "gemmamills01"
      permission   = "push"
      name         = "Gemma Mills"
      email        = "gemma.mills@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Get access to Delius-IAPS on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-08-28"
    },
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
      github_user  = "PeteWV1"
      permission   = "push"
      name         = "Peter Wightman"
      email        = "peter.wightman@version1.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Modernisation Platform"
      added_by     = "silviana.horga@digital.justice.gov.uk"
      review_after = "2024-09-25"
    },
    {
      github_user  = "jamesashton-roc"
      permission   = "push"
      name         = "James Ashton"
      email        = "james.ashton@roctechnologies.com"
      org          = "ROC"
      reason       = "Get access to equip github actions on Modernisation Platform"
      added_by     = "edward.proctor@digital.justice.gov.uk"
      review_after = "2024-12-14"
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
  ]
}
