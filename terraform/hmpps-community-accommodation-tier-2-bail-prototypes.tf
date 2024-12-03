module "hmpps-community-accommodation-tier-2-bail-prototypes" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-community-accommodation-tier-2-bail-prototypes"
  collaborators = [
    {
      github_user  = "apdig"
      permission   = "push"
      name         = "André Petheram"
      email        = "andre.petheram@oxfordinsights.com"
      org          = "Oxford Insights"
      reason       = "CAS 2 Bail Alpha Development"
      added_by     = "ross.jones@digital.justice.gov.uk"
      review_after = "2025-06-30"
    },
    {
      github_user  = "chrisadesign"
      permission   = "push"
      name         = "Chris Armstrong"
      email        = "mail@chrisarmstrong.io"
      org          = "Oxford Insights"
      reason       = "CAS 2 Bail Alpha Development"
      added_by     = "ross.jones@digital.justice.gov.uk"
      review_after = "2025-06-30"
    },
    {
      github_user  = "simonwo"
      permission   = "push"
      name         = "Simon Worthington"
      email        = "simon@register-dynamics.co.uk"
      org          = "Oxford Insights"
      reason       = "CAS 2 Bail Alpha Development"
      added_by     = "ross.jones@digital.justice.gov.uk"
      review_after = "2025-06-30"
    },
    {
      github_user  = "beccagorton"
      permission   = "push"
      name         = "Becca Gorton"
      email        = "becca.gorton@guest.vivace.tech"
      org          = "TPXImpact"
      reason       = "CAS 2 Bail Alpha Development"
      added_by     = "ross.jones@digital.justice.gov.uk"
      review_after = "2025-06-30"
    },
    {
      github_user  = "Francesca245"
      permission   = "push"
      name         = "Francesca Scavone"
      email        = "francesca.scavone@guest.vivace.tech"
      org          = "TPXImpact"
      reason       = "CAS 2 Bail Alpha Development"
      added_by     = "ross.jones@digital.justice.gov.uk"
      review_after = "2025-06-30"
    }
  ]
}
