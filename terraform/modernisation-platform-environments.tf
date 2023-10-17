module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
    {
      github_user  = "hullcoastie"
      permission   = "push"
      name         = "John Broom"
      email        = "John.Broom@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-24"
    },
    {
      github_user  = "jamesashton-roc"
      permission   = "push"
      name         = "James Ashton"
      email        = "James.Ashton@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-24"
    },
    {
      github_user  = "craigygordon"
      permission   = "push"
      name         = "Craig Gordon"
      email        = "Craig.Gordon@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-24"
    },
    {
      github_user  = "andylandroc"
      permission   = "push"
      name         = "Andy Land"
      email        = "Andy.Land@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-24"
    },
    {
      github_user  = "trudley"
      permission   = "push"
      name         = "Tom Rudley"
      email        = "Tom.Rudley@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-24"
    },
    {
      github_user  = "helenvickers-roc"
      permission   = "push"
      name         = "Helen Vickers"
      email        = "Helen.Vickers@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-24"
    },
    {
      github_user  = "umeshc-roy"
      permission   = "push"
      name         = "Umesh Ray"
      email        = "Umesh.Ray@lumen.com"
      org          = "Lumen"
      reason       = "Get access to PPUD on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-04"
    },
    {
      github_user  = "pankaj-pant-lumen"
      permission   = "push"
      name         = "Pankaj Pant"
      email        = "Pankaj.Pant@lumen.com"
      org          = "Lumen"
      reason       = "Get access to PPUD on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-11-04"
    },
    {
      github_user  = "larnal-lumen"
      permission   = "push"
      name         = "Luis Martinez Arnal"
      email        = "Luis.MartinezArnal@lumen.com"
      org          = "Lumen"
      reason       = "Get access to PPUD on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-11-04"
    },
    {
      github_user  = "gemmamills01"
      permission   = "push"
      name         = "Gemma Mills"
      email        = "gemma.mills@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Get access to Delius-IAPS on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-03-01"
    },
    {
      github_user  = "tedcolver01"
      permission   = "push"
      name         = "Ted Colver"
      email        = "gemma.mills@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Get access to Delius-IAPS on Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-03-01"
    },
    {
      github_user  = "simonytta"
      permission   = "push"
      name         = "Simona Treivase"
      email        = "Simona.Treivase@justice.gov.uk"
      org          = "Agilisys"
      reason       = "Get access to Data Insights Hub on the Modernisation Platform"
      added_by     = "modernisation-platform@digital.justice.gov.uk"
      review_after = "2024-05-25"
    },
    {
      github_user  = "nbuckingham72"
      permission   = "push"
      name         = "nick buckingham"
      email        = "nick.buckingham@lumen.com"
      org          = "Lumen Technologies"
      reason       = "The user will manage the PPUD terraform code on day to day basis"
      added_by     = "mark.hardy@digital.justice.gov.uk"
      review_after = "2023-12-31"
    },
  ]
}
