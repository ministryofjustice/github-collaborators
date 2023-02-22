module "yjaf-mule-mis-processor" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-mule-mis-processor"
  collaborators = [
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
      github_user  = "vasildimitrov22"
      permission   = "push"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-18"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-08-23"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New YJAF Full Stack Developer"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-12"
    },
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
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC Software Solutions"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-05-26"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-09-01"
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
  ]
}
