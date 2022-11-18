module "modernisation-platform-environments" {
  source     = "./modules/repository-collaborators"
  repository = "modernisation-platform-environments"
  collaborators = [
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
    {
      github_user  = "agilisys-agardner"
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-02-16"
    },
  ]
}
