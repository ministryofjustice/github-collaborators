module "yjsm-hub-svc" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-hub-svc"
  collaborators = [
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "Olivier.Gaubert@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "AndrewRichards72"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "andrew.richards@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "JWGNPS"
      permission   = "push"
      name         = "James Grunewald"
      email        = "james.grunewald@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2021-12-11"
    },
    {
      github_user  = "brbaje-dev"
      permission   = "admin"
      name         = "Ben Bajek"
      email        = "ben.bajek@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@northgateps.com> Devops for northgate"
      review_after = "2021-12-01"
    },
    {
      github_user  = "henrycarteruk"
      permission   = "admin"
      name         = "Henry Carter"
      email        = "henry.carter@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@northgateps.com> Devops for northgate"
      review_after = "2021-12-01"
    },
    {
      github_user  = "waheedanjum"
      permission   = "push"
      name         = "Muhammad Waheed Anjum"
      email        = "muhammad.anjum@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding Tasks"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk"
      review_after = "2021-12-31"
    },
    {
      github_user  = "boydingham"
      permission   = "push"
      name         = "Boyd Cunningham"
      email        = "Boyd.cunningham@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@northgateps.com> Devops for northgate"
      review_after = "2021-12-31"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@northgateps.com"
      review_after = "2022-12-31"
    },
  ]
}
