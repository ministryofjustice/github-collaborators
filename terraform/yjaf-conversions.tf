module "yjaf-conversions" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-conversions"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2022-12-13"
    },
    {
      github_user  = "vasildimitrov22"
      permission   = "push"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@necsws.com> Devops for NEC Software Solutions"
      review_after = "2022-12-18"
    },
    {
      github_user  = "griffinjuknps"
      permission   = "admin"
      name         = "Jeremy Griffin"
      email        = "jeremy.griffin@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding tasks"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-06-02"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@necsws.com"
      review_after = "2023-07-21"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New YJAF Full Stack Developer"
      added_by     = "Antony Bishop antony.bishop@digital.justice.gov.uk"
      review_after = "2023-12-23"
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
      review_after = "2022-12-31"
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
    {
      github_user  = "vikasnecsws"
      permission   = "admin"
      name         = "Vikas Omar"
      email        = "vikas.omar@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-06-07"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-09-01"
    },
  ]
}
