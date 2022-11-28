module "yjaf-gateway" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-gateway"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "Northgate"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2022-12-13"
    },
    {
      github_user  = "griffinjuknps"
      permission   = "admin"
      name         = "Jeremy Griffin"
      email        = "jeremy.griffin@northgateps.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF developer. Needing access to the work on BackEnd coding tasks"
      added_by     = "<gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2022-12-02"
    },
    {
      github_user  = "VasilDimitrov22"
      permission   = "push"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@northgateps.com"
      org          = "NPS (northgate)"
      reason       = "Part of the Northgate supplier team for the YJB YJAF system"
      added_by     = "Greg Whiting <greg.whiting@northgateps.com> Devops for northgate"
      review_after = "2022-12-18"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Greg Whiting - greg.whiting@northgateps.com"
      review_after = "2023-02-24"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "New YJAF Full Stack Developer"
      added_by     = "Jo Harvey joanna.harvey@necsws.com"
      review_after = "2022-12-12"
    },
    {
      github_user  = "craig-ashford-nec"
      permission   = "maintain"
      name         = "Craig Ashford"
      email        = "craig.ashford@necsws.com"
      org          = "NEC SWS"
      reason       = "New front end developer on YJAF team"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-02-07"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC"
      reason       = "Part of the Northgate supplier team who are now NEC for the YJB YJAF system"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2022-12-31"
    },
    {
      github_user  = "AndrewTRichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-26"
    },
    {
      github_user  = "vikasnecsws"
      permission   = "admin"
      name         = "Vikas Omar"
      email        = "vikas.omar@necsws.com"
      org          = "NEC"
      reason       = "YJAF (new developer)"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-06-07"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC"
      reason       = "YJAF (new developer)"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-09-01"
    },
    {
      github_user  = "olusegunonec"
      permission   = "admin"
      name         = "Olusegun Odunukan"
      email        = "olusegun.odunukan@necsws.com"
      org          = "NEC"
      reason       = "YJAF"
      added_by     = "Tony Bishop antony.bishop@digital.justice.gov.uk"
      review_after = "2023-11-22"
    },
  ]
}
