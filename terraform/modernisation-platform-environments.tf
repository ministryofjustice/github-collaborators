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
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2022-11-01"
    },
    {
      github_user  = "jamesashton-roc"
      permission   = "push"
      name         = "James Ashton"
      email        = "James.Ashton@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2022-11-01"
    },
    {
      github_user  = "md-roc"
      permission   = "push"
      name         = "Mittul Datani"
      email        = "Mittul.Datani@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2022-11-01"
    },
    {
      github_user  = "trudley"
      permission   = "push"
      name         = "Tom Rudley"
      email        = "Tom.Rudley@roctechnologies.com"
      org          = "Roc Technologies"
      reason       = "Roc have built and are supporting the HMPPS Equip application on the Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2022-11-01"
    },
    {
      github_user  = "agilisys-agardner"
      permission   = "push"
      name         = "Andrew Gardener"
      email        = "andrew.gardner@agilisys.co.uk"
      org          = "Agilisys"
      reason       = "Get access to data-and-insights-hub on Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-02-23"
    },
    {
      github_user  = "umeshc-roy"
      permission   = "push"
      name         = "Umesh Ray"
      email        = "Umesh.Ray@lumen.com"
      org          = "Lumen"
      reason       = "Get access to PPUD on Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-11-04"
    },
    {
      github_user  = "pankaj-pant-lumen"
      permission   = "push"
      name         = "Pankaj Pant"
      email        = "Pankaj.Pant@lumen.com"
      org          = "Lumen"
      reason       = "Get access to PPUD on Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-11-04"
    },
    {
      github_user  = "larnal-lumen"
      permission   = "push"
      name         = "Luis Martinez Arnal"
      email        = "Luis.MartinezArnal@lumen.com"
      org          = "Lumen"
      reason       = "Get access to PPUD on Modernisation Platform"
      added_by     = "Modernisation Platform team, modernisation-platform@digital.justice.gov.uk"
      review_after = "2023-11-04"
    },
  ]
}
