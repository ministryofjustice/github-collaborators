module "yjaf-serious-incidents" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-serious-incidents"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "VasilDimitrov22"
      permission   = "admin"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@northgateps.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-07-21"
    },
    {
      github_user  = "craig-ashford-nec"
      permission   = "admin"
      name         = "Craig Ashford"
      email        = "craig.ashford@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
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
  ]
}
