module "yjsm-hubadmin" {
  source     = "./modules/repository-collaborators"
  repository = "yjsm-hubadmin"
  collaborators = [
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-18"
    },
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-13"
    },
    {
      github_user  = "griffinjuknps"
      permission   = "admin"
      name         = "Jeremy Griffin"
      email        = "jeremy.griffin@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding tasks"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-06-02"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-21"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New YJAF Full Stack Developer"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-23"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC Software Solutions"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-11-22"
    },
    {
      github_user  = "markstanley-nps"
      permission   = "pull"
      name         = "Mark Stanley"
      email        = "mark.stanley@necsws.com"
      org          = "NECSWS"
      reason       = "Developer"
      added_by     = "Mick.Ewers@yjb.gov.uk"
      review_after = "2024-02-15"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NECSWS"
      reason       = "Development & support related actions on YJAF"
      added_by     = "Mick.Ewers@yjb.gov.uk"
      review_after = "2023-06-07"
    },
  ]
}
