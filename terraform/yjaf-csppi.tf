module "yjaf-csppi" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-csppi"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-12-13"
    },
    {
      github_user  = "vasildimitrov22"
      permission   = "push"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-12-18"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-07-21"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New YJAF Full Stack Developer"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-12-12"
    },
    {
      github_user  = "craig-ashford-nec"
      permission   = "admin"
      name         = "Craig Ashford"
      email        = "craig.ashford@necsws.com"
      org          = "NEC SWS"
      reason       = "New front end developer on YJAF team"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-02-07"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-12-18"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC Software Solutions"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-05-26"
    },
  ]
}
